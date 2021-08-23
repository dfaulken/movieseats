# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Changing seat status', type: :feature do
  it 'default', js: true do
    venue = create :venue, rows: 3, columns: 3
    seat = venue.seats.where(row: 2, column: 2).first
    visit "/venues/#{venue.id}"
    page.find('td', text: seat.name).find('form').find('input[type=checkbox]').click
    expect(page).to have_css('#notice', text: 'Seat updated.')
  end

  it 'handles errors'
end
