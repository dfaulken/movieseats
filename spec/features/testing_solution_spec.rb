require 'rails_helper'

RSpec.describe 'Testing the solution', type: :feature do
  let(:venue) { create :venue }

  it 'solver does not encounter an error', js: true do
    visit "/venues/#{venue.id}/test_solution"
    solution = page.find('textarea.solution_field')
    click_on 'Test solution'
    expect(solution.value).to eq '{}'
  end

  scenario 'solver encounters an error'
end
