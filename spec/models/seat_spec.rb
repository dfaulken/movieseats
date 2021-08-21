require 'rails_helper'

RSpec.describe 'Seat', type: :model do
  describe 'row_letter' do
  	it 'gives single letters for indices  1-26'
  	it 'gives double letters for indices 27-52'
  end

  describe 'at (scope)' do
    it 'gives the seat with specified row and column'
  end
end