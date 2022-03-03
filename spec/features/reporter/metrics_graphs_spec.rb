# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics management', js: true do
  def plot_is_empty(css_id)
    within(:css, css_id) { expect(page).to have_content 'There is no data for this metric yet' }
  end

  def plot_is_populated(css_id)
    within(:css, css_id) { expect(page).to_not have_content 'There is no data for this metric yet' }
  end

  context 'If there is no data in the system' do
    before { login_as(FactoryBot.create(:reporter)) }

    specify 'The graphs should show an appropriate message' do
      visit '/metrics'
      expect(page).to have_current_path '/metrics'

      plot_is_empty('#visits-barchart-plot')
      plot_is_empty('#visits-linechart-plot')
      within(:css, '#visits-barchart-title') { expect(page).to have_content 'Site Visits by Page (Total: 0)' }

      plot_is_empty('#registrations-barchart-plot')
      plot_is_empty('#registrations-linechart-plot')
      plot_is_empty('#registrations-by-type-barchart-plot')
      within(:css, '#registrations-barchart-title') do
        expect(page).to have_content 'Site Registrations by Vocation (Total: 0)'
      end

      plot_is_empty('#feature-shares-barchart-plot')
      within(:css, '#feature-shares-barchart-title') { expect(page).to have_content 'Shares By Feature (Total: 0)' }

      #within(:css, '#feature-views-barchart-plot') { expect(page).to have_content 'There is no data for this metric yet' }
      #within(:css, '#feature-views-barchart-title') { expect(page).to have_content 'Clicks By Feature (Total: 0)' }
    end
  end

  context 'If there is data in the system' do
    before { login_as(FactoryBot.create(:reporter)) }

    specify 'If there are visitor statistics' do
      FactoryBot.create :visit

      visit '/metrics'
      expect(page).to have_current_path '/metrics'

      plot_is_populated('#visits-barchart-plot')
      plot_is_populated('#visits-barchart-title')
      plot_is_populated('#visits-linechart-plot')

      within(:css, '#visits-barchart-title') { expect(page).to have_content 'Site Visits by Page (Total: 1)' }
    end

    specify 'If there are registrations' do
      FactoryBot.create :newsletter

      visit '/metrics'
      expect(page).to have_current_path '/metrics'

      plot_is_populated('#registrations-barchart-plot')
      plot_is_populated('#registrations-barchart-title')
      plot_is_populated('#registrations-linechart-plot')
      plot_is_populated('#registrations-by-type-barchart-plot')

      within(:css, '#registrations-barchart-title') do
        expect(page).to have_content 'Site Registrations by Vocation (Total: 1)'
      end
    end

    specify 'If there are feature shares' do
      FactoryBot.create :share

      visit '/metrics'
      expect(page).to have_current_path '/metrics'

      plot_is_populated('#feature-shares-barchart-plot')
      within(:css, '#feature-shares-barchart-title') { expect(page).to have_content 'Shares By Feature (Total: 1)' }
    end

    specify 'If there are feature clicks/visits' do
      skip 'WAITING FOR FEATURE IMPLEMENTATION'

      visit '/metrics'
      expect(page).to have_current_path '/metrics'
    end
  end

  context 'Security' do
    specify 'If I am not logged in, I cannot view metrics' do
      visit '/metrics'
      within(:css, '.nav') { expect(page).not_to have_content 'Metrics' }
      expect(page).not_to have_content 'Metrics Summary'
      expect(page).to have_current_path('/users/sign_in')
    end

    context 'If I am an admin' do
      before { login_as(FactoryBot.create(:admin)) }
      specify 'I can view metrics' do
        visit '/metrics'
        within(:css, '.nav') { expect(page).to have_content 'Metrics' }
        expect(page).to have_content 'Metrics Summary'
      end
    end

    context 'If I am an reporter' do
      before { login_as(FactoryBot.create(:reporter)) }
      specify 'I can view metrics' do
        visit '/metrics'
        within(:css, '.nav') { expect(page).to have_content 'Metrics' }
        expect(page).to have_content 'Metrics Summary'
      end
    end

    context 'If I am not an admin or reporter' do
      before { login_as(FactoryBot.create(:customer)) }
      specify ', I cannot view metrics' do
        visit '/metrics'
        within(:css, '.nav') { expect(page).not_to have_content 'Metrics' }
        expect(page).not_to have_content 'Metrics Summary'
      end
    end
  end
end
