require 'rails_helper'

RSpec.describe MovieSeatsSolver do
	it 'has an available status that is the same as for Seat'
	it 'has 26 row letters'

	describe 'parse_input_data!' do
		it 'parses input data format into Venue and Seat objects'
		it 'groups available seats together'
	end

	describe 'solution_json_data' do
		context 'solve has happened' do
			it 'returns the input data for the seats in the solution'
		end
		solve 'solve has not happened' do
			it 'returns an empty hash'
		end
	end

	describe 'solve!' do
		context 'requested group size is 1' do
			it 'finds the seat that is closest to the front, all other things being equal'
			it 'finds the seat that is closest to the center, all other things being equal'
		end
		context 'requested group size is greater than 1' do
			it 'discards groups of closer seats if they are too small'
			it 'finds the best subgroup of the best group of available seats'
		end
	end
end