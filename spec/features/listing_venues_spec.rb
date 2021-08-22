require 'rails_helper'

RSpec.feature 'Listing venues', type: :feature do
  scenario 'with no venues present' do
    visit '/venues'
    expect(page).not_to have_css 'table'
  end
  scenario 'with venues present' do
    create :venue
    visit '/venues'
    expect(page).to have_css 'table'
    expect(page).to have_css('tbody tr', count: 1)
    expect(page).to have_text 'Show'
    expect(page).to have_text 'Edit'
    expect(page).to have_text 'Destroy'
  end
end
