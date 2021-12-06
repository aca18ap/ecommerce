require 'rails_helper'

describe 'Metrics management', js: true do
  context 'If there is no data in the system' do
    before { login_as(FactoryBot.create(:reporter)) }

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
    before { login_as(FactoryBot.create(:reporter)) }

    specify 'If there are visitor statistics' do
      FactoryBot.create :visit_root
      FactoryBot.create :visit_root
      FactoryBot.create :visit_reviews

      visit '/metrics'
      within(:css, '#visits-barchart-plot') { expect(page).to have_content '/' }
      within(:css, '#visits-barchart-plot') { expect(page).to have_content 2.00 }
      within(:css, '#visits-barchart-plot') { expect(page).to have_content '/reviews' }
      within(:css, '#visits-barchart-plot') { expect(page).to have_content 1.00 }
      within(:css, '#visits-linechart-plot') { expect(page).to have_content 3.00 }
    end

    specify 'If there are registrations' do
      # Create 1 customer registration for each tier and 1 business registration
      FactoryBot.create :free_customer_newsletter
      FactoryBot.create :solo_customer_newsletter
      FactoryBot.create :family_customer_newsletter
      FactoryBot.create :business_newsletter

      visit '/metrics'
      within(:css, '#registrations-barchart-plot') { expect(page).to have_content 'Customer' }
      within(:css, '#registrations-barchart-plot') { expect(page).to have_content 3.00 }
      within(:css, '#registrations-barchart-plot') { expect(page).to have_content 'Business' }
      within(:css, '#registrations-barchart-plot') { expect(page).to have_content 1.00 }
      within(:css, '#registrations-linechart-plot') { expect(page).to have_content 4.00 }
      within(:css, '#registrations-by-type-barchart-plot') { expect(page).to have_content 'Free' }
      within(:css, '#registrations-by-type-barchart-plot') { expect(page).to have_content 'Solo' }
      within(:css, '#registrations-by-type-barchart-plot') { expect(page).to have_content 'Family' }
      within(:css, '#registrations-by-type-barchart-plot') { expect(page).to have_content 1.00 }
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
