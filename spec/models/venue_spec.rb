require 'rails_helper'

RSpec.describe 'Venue', type: :model do
	it "can't have fewer than 1 row"
	it "can't have fewer than 1 column"

	it 'populates unavailable seats on creation' do
		venue = Venue.create columns: 5, rows: 5
		expect(venue.seats.count).to eq 25
		expect(venue.seats.where(available: false).count).to eq 25
	end
end