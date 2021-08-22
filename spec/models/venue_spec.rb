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

	describe 'seat_index' do
		let(:venue) { create :venue, rows: 3, columns: 3 }
		it 'returns 0-indexed position of seat at 1-indexed row and column in seats ordered by row and column' do
			expect(venue.seat_index 1, 1).to eq 0
			expect(venue.seat_index 2, 1).to eq 3
			expect(venue.seat_index 3, 3).to eq 8
		end
	end
end