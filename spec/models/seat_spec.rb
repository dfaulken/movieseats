require 'rails_helper'

RSpec.describe 'Seat', type: :model do
  it "can't be in a row less than 1"
  it "can't be in a column less than 1"
  it 'has 26 row letters'

  describe 'at (scope)' do
    it 'gives the seat with specified row and column'
  end

  describe 'row_letter' do
  	it 'gives single letters for indices  1-26'
  	it 'gives double letters for indices 27-52'
    it 'gives triple letters for indices 52-78'
  end

  describe 'status' do
    it 'gives the available status for available seats'
    it 'gives the unavailable status for unavailable seats'
  end
end