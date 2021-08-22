require 'rails_helper'

RSpec.feature 'Deleting venues', type: :feature do
  scenario 'default' do
    venue = create :venue
    visit '/venues'
    seat_count = venue.seats.count
    expect { click_on 'Destroy' }.to change { [Venue.count, Seat.count] }.from([1, seat_count]).to([0, 0])
    expect(page).to have_text 'Venue was successfully destroyed.'
  end
end
