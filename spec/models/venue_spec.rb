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
end