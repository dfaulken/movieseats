require 'rails_helper'

RSpec.feature 'Creating venues', type: :feature do
  scenario 'entering invalid attributes' do
    visit '/venues/new'
    fill_in 'Rows', with: 0
    fill_in 'Columns', with: 0
    expect { click_on 'Create Venue' }.not_to change { Venue.count }
    expect(page).to have_text '2 errors prohibited this venue from being saved:'
  end
  scenario 'entering valid attributes' do
    visit '/venues/new'
    fill_in 'Rows', with: 1
    fill_in 'Columns', with: 1
    expect { click_on 'Create Venue' }.to change { Venue.count }.from(0).to(1)
    expect(page.current_path).to eq "/venues/#{Venue.last.id}"
    expect(page).to have_text 'Venue was successfully created.'
  end
end
