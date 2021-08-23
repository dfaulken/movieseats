# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Freeing sample seat groups', type: :feature do
  it 'default' do
    venue = create :venue, rows: 4, columns: 4
    visit "/venues/#{venue.id}"
    fill_in 'Free sample groups of size:', with: 2
    fill_in 'Number of groups:', with: 2
    click_on 'Free group'
    expect(page).to have_text 'Sample seat group(s) freed.'
  end
end
