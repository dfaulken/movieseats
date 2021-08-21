require 'rails_helper'

RSpec.describe VenuesHelper do
	describe 'solution_input_json' do
		let(:venue) { create :venue }
		let(:seat) { venue.seats.first }
		let(:raw_result) { solution_input_json venue }
		let(:result) { JSON.parse raw_result }
		it 'returns JSON' do
			expect { JSON.parse raw_result }.not_to raise_error
		end
		it 'gives venue layout data' do
			expect(result).to have_key 'venue'
			expect(result['venue']).to have_key 'layout'
			layout = result['venue']['layout']
			expect(layout).to have_key 'rows'
			expect(layout['rows']).to eq venue.rows
			expect(layout).to have_key 'columns'
			expect(layout['columns']).to eq venue.columns
		end
		it 'gives seat data' do
			expect(result).to have_key 'seats'
			seats_data = result['seats']
			expect(seats_data.size).to eq venue.seats.count
			expect(seats_data.keys).to eq venue.seats.map(&:name)
			seat_data = seats_data[seat.name]
			expect(seat_data).to have_key 'column'
			expect(seat_data['column']).to eq seat.column
			expect(seat_data).to have_key 'status'
			expect(seat_data['status']).to eq seat.status
		end
		it 'uses seat name for ID' do
			seat_data = result['seats'][seat.name]
			expect(seat_data).to have_key 'id'
			expect(seat_data['id']).to eq seat.name
		end
		it 'uses downcased row letter for seat rows' do
			seat_data = result['seats'][seat.name]
			expect(seat_data).to have_key 'row'
			expect(seat_data['row']).to eq seat.row_letter.downcase
		end
	end
end