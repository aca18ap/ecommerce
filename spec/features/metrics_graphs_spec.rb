require 'rails_helper'

describe 'Metrics management' do
  context 'If there is no data in the system' do
    specify 'The graphs should show an appropriate message' do
      visit '/metrics'
      within(:css, '#visits-barchart-plot') { expect(page).to have_content 'There is no data for this metric yet' }
      within(:css, '#visits-linechart-plot') { expect(page).to have_content 'There is no data for this metric yet' }
      within(:css, '#registrations-barchart-plot') { expect(page).to have_content 'There is no data for this metric yet' }
      within(:css, '#registrations-linechart-plot') { expect(page).to have_content 'There is no data for this metric yet' }
      within(:css, '#registrations-by-type-barchart-plot') { expect(page).to have_content 'There is no data for this metric yet' }
      # NEED TO TEST MAPS SOMEHOW
    end
  end

  context 'If there is data in the system' do
    specify 'If there are registrations' do
      # One customer registration and one business registration
      FactoryBot.create :free_customer
      FactoryBot.create :business
    end
  end

  context 'Security' do
    specify 'If I am not logged in, I cannot view metrics' do
      visit '/metrics'
      expect(page).not_to have_content 'Metrics Summary'
      expect(page).to have_current_path('/')
    end

    specify 'If I am not an admin or reporter, I cannot view metrics' do
      before { login_as(FactoryBot.create(:customer)) }
      visit '/metrics'
      expect(page).not_to have_content 'Metrics Summary'
      expect(page).to have_current_path('/')
    end
  end
end