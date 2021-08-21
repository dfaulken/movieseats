require 'rails_helper'

RSpec.describe 'Testing solution', type: :request do
	it 'requires venue parameters'
	it 'it only permits input_data and requested_group_size parameters'
	it 'calls MovieSeatsSolver#solve'
	it 'parses input_data as JSON'
	it 'parses requested_group_size as an integer'
	context 'solver works as expected' do
		it 'returns a 200 with response data as JSON'
	end
	context 'solver does not work as expected' do
		it 'returns a 500'
	end
end