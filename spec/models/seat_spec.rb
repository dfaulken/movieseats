require 'rails_helper'

RSpec.describe 'Seat', type: :model do
  it "can't be in a row less than 1" do
    seat = build :seat, row: 0
    expect(seat).not_to be_valid
    expect(seat.errors).to have_key 'row'
    expect(seat.errors['row']).to include 'must be greater than 0'
  end
  it "can't be in a column less than 1" do
    seat = build :seat, column: 0
    expect(seat).not_to be_valid
    expect(seat.errors).to have_key 'column'
    expect(seat.errors['column']).to include 'must be greater than 0'
  end
  it 'has 26 row letters' do
    expect(Seat::LETTERS.count).to eq 26
  end

  describe 'at (scope)' do
    it 'gives a collection of seats with the specified row and column' do
      venue = create :venue, rows: 3, columns: 4
      seat = venue.seats.where(row: 2, column: 3).first
      expect(venue.seats.at 2, 3).to include seat
    end
  end

  describe 'row_letter' do
  	it 'gives single letters for rows 1-26' do
      expect(create(:seat, row:  1).row_letter).to eq 'A'
      expect(create(:seat, row: 26).row_letter).to eq 'Z'
    end
  	it 'gives double letters for rows 27-52' do
      expect(create(:seat, row: 27).row_letter).to eq 'AA'
      expect(create(:seat, row: 52).row_letter).to eq 'ZZ'
    end
    it 'gives triple letters for rows 53-78' do
      expect(create(:seat, row: 53).row_letter).to eq 'AAA'
      expect(create(:seat, row: 78).row_letter).to eq 'ZZZ'
    end
  end

  describe 'status' do
    it 'gives the available status for available seats' do
      expect(create(:seat, available: true).status).to eq Seat::AVAILABLE_STATUS
    end
    it 'gives the unavailable status for unavailable seats' do
      expect(create(:seat, available: false).status).to eq Seat::UNAVAILABLE_STATUS
    end
  end
end