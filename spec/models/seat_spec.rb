require 'rails_helper'

RSpec.describe 'Seat', type: :model do
  describe 'at (scope)' do
    it 'gives the seat with specified row and column'
  end

  describe 'row_letter' do
  	it 'gives single letters for indices  1-26'
  	it 'gives double letters for indices 27-52'
  end

  describe 'status' do
    it 'gives the available status for available seats'
    it 'gives the unavailable status for unavailable seats'
  end
end