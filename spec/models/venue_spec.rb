# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Venue', type: :model do
  it "can't have fewer than 1 row" do
    venue = build :venue, rows: 0
    expect(venue).not_to be_valid
    expect(venue.errors).to have_key 'rows'
    expect(venue.errors['rows']).to include 'must be greater than 0'
  end

  it "can't have fewer than 1 column" do
    venue = build :venue, columns: 0
    expect(venue).not_to be_valid
    expect(venue.errors).to have_key 'columns'
    expect(venue.errors['columns']).to include 'must be greater than 0'
  end

  it 'populates unavailable seats on creation' do
    venue = create :venue, columns: 5, rows: 5
    expect(venue.seats.count).to eq 25
    expect(venue.seats.where(available: false).count).to eq 25
  end

  describe 'free_sample_seat_group' do
    it 'frees up a seat group of requested size' do
      10.times do
        venue = create :venue, rows: 5, columns: 5
        venue.free_sample_seat_group size: 3
        free_seats = venue.seats.available
        expect(free_seats.count).to eq 3
        expect(free_seats.pluck(:row).uniq.count).to eq 1
        expect(free_seats.pluck(:column).max - free_seats.pluck(:column).min).to eq 2
      end
    end
  end

  describe 'seat_index' do
    let(:venue) { create :venue, rows: 3, columns: 3 }

    it 'returns 0-indexed position of seat at 1-indexed row and column in seats ordered by row and column' do # rubocop:disable Layout/LineLength
      expect(venue.seat_index(1, 1)).to eq 0
      expect(venue.seat_index(2, 1)).to eq 3
      expect(venue.seat_index(3, 3)).to eq 8
    end
  end
end
