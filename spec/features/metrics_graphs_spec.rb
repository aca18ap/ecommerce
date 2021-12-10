require 'rails_helper'

describe 'Metrics management', js: true do
  context 'If there is no data in the system' do
    before { login_as(FactoryBot.create(:reporter)) }

    specify 'The graphs should show an appropriate message' do
      visit '/metrics'
      within(:css, '#visits-barchart-plot') { expect(page).to have_content 'There is no data for this metric yet' }
      within(:css, '#visits-barchart-title') { expect(page).to have_content 'Site Visits by Page (Total: 0)' }
      within(:css, '#visits-linechart-plot') { expect(page).to have_content 'There is no data for this metric yet' }

      within(:css, '#registrations-barchart-plot') { expect(page).to have_content 'There is no data for this metric yet' }
      within(:css, '#registrations-barchart-title') { expect(page).to have_content 'Site Registrations by Vocation (Total: 0)' }
      within(:css, '#registrations-linechart-plot') { expect(page).to have_content 'There is no data for this metric yet' }
      within(:css, '#registrations-by-type-barchart-plot') { expect(page).to have_content 'There is no data for this metric yet' }

      within(:css, '#feature-interest-barchart-plot') { expect(page).to have_content 'There is no data for this metric yet' }
      within(:css, '#feature-interest-barchart-title') { expect(page).to have_content 'Clicks By Feature (Total: 0)' }
      within(:css, '#feature-shares-barchart-plot') { expect(page).to have_content 'There is no data for this metric yet' }
      within(:css, '#feature-shares-barchart-title') { expect(page).to have_content 'Shares By Feature (Total: 0)' }

      # TEST MAPS AND USER FLOW CHART
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

      # TEST MAP AND USER FLOW CHARTS
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

      # TEST MAP
    end

    specify 'If there are feature shares' do
      skip 'WAITING FOR FEATURE IMPLEMENTATION'
    end

    specify 'If there are feature clicks/visits' do
      skip 'WAITING FOR FEATURE IMPLEMENTATION'
    end
  end

  context 'Security' do
    specify 'If I am not logged in, I cannot view metrics' do
      visit '/metrics'
      within(:css, '.nav') { expect(page).not_to have_content 'Metrics' }
      expect(page).not_to have_content 'Metrics Summary'
      expect(page).to have_current_path('/')
    end

    context 'If I am not an admin or reporter' do
      before { login_as(FactoryBot.create(:customer)) }
      specify ', I cannot view metrics' do
        visit '/metrics'
        within(:css, '.nav') { expect(page).not_to have_content 'Metrics' }
        expect(page).not_to have_content 'Metrics Summary'
        expect(page).to have_current_path('/')
      end
    end
  end
end
