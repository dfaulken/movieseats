require 'rails_helper'

RSpec.feature 'Viewing venues', type: :feature do
  scenario 'default' do
    venue = create :venue, rows: 2, columns: 3
    visit "/venues/#{venue.id}"
    expect(page).to have_text "Rows: #{venue.rows}"
    expect(page).to have_text "Columns: #{venue.columns}"
    expect(page).to have_css 'table.seats'
    expect(page).to have_css('table.seats td', count: 6)
    expect(page).to have_text 'Test Solution'
  end
end
