# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics management', js: true do
  def plot_is_empty(css_id)
    within(:css, css_id) { expect(page).to have_content 'No data' }
  end

  def plot_is_populated(css_id)
    within(:css, css_id) { expect(page).to_not have_content 'no data' }
  end

  context 'If there is no data in the system' do
    before { login_as(FactoryBot.create(:reporter), scope: :staff) }

    specify 'The graphs should show an appropriate message' do
      visit metrics_path
      expect(page).to have_current_path metrics_path

      # Products
      plot_is_empty('#products-barchart-plot')
      plot_is_empty('#products-linechart-plot')
      within(:css, '#products-barchart-title') { expect(page).to have_content 'Product Additions By Category (Total: 0)' }

      plot_is_empty('#affiliates-barchart-plot')
      within(:css, '#affiliates-barchart-title') { expect(page).to have_content 'Affiliate Product Additions By Category (Total: 0)' }

      plot_is_empty('#affiliate-views-linechart-plot')
      within(:css, '#affiliate-views-linechart-title') { expect(page).to have_content 'Affiliate Product Views Over Time (Total: 0)' }

      # Visits
      find('#open-visitor-metrics-tab').click
      plot_is_empty('#visits-barchart-plot')
      plot_is_empty('#visits-linechart-plot')
      within(:css, '#visits-barchart-title') { expect(page).to have_content 'Site Visits by Page (Total: 0)' }

      # Registrations
      find('#open-registration-metrics-tab').click
      plot_is_empty('#registrations-barchart-plot')
      plot_is_empty('#registrations-linechart-plot')
      within(:css, '#registrations-barchart-title') { expect(page).to have_content 'Site Registrations by Vocation (Total: 0)' }

      # Shares
      find('#open-shares-metrics-tab').click
      plot_is_empty('#feature-shares-barchart-plot')
      within(:css, '#feature-shares-barchart-title') { expect(page).to have_content 'Shares By Feature (Total: 0)' }
    end
  end

  context 'If there is data in the system' do
    before { login_as(FactoryBot.create(:reporter), scope: :staff) }

    specify 'If there are visitor statistics' do
      FactoryBot.create :visit

      visit metrics_path
      expect(page).to have_current_path metrics_path

      find('#open-visitor-metrics-tab').click
      plot_is_populated('#visits-barchart-plot')
      plot_is_populated('#visits-barchart-title')
      plot_is_populated('#visits-linechart-plot')

      within(:css, '#visits-barchart-title') { expect(page).to have_content 'Site Visits by Page (Total: 1)' }
    end

    specify 'If there are registrations' do
      FactoryBot.create :customer_registration

      visit metrics_path
      expect(page).to have_current_path metrics_path

      find('#open-registration-metrics-tab').click
      plot_is_populated('#registrations-barchart-plot')
      plot_is_populated('#registrations-barchart-title')
      plot_is_populated('#registrations-linechart-plot')

      within(:css, '#registrations-barchart-title') do
        expect(page).to have_content 'Site Registrations by Vocation (Total: 1)'
      end
    end

    specify 'If there are feature shares' do
      FactoryBot.create :share

      visit metrics_path
      expect(page).to have_current_path metrics_path

      find('#open-shares-metrics-tab').click
      plot_is_populated('#feature-shares-barchart-plot')
      within(:css, '#feature-shares-barchart-title') { expect(page).to have_content 'Shares By Feature (Total: 1)' }
    end

    specify 'If there are products' do
      FactoryBot.create :product

      visit metrics_path
      expect(page).to have_current_path metrics_path

      plot_is_populated('#products-barchart-plot')
      plot_is_populated('#products-linechart-plot')
      within(:css, '#products-barchart-title') { expect(page).to have_content 'Product Additions By Category (Total: 1)' }
    end

    specify 'If there are affiliate products' do
      FactoryBot.create(:product, business_id: 1)

      visit metrics_path
      expect(page).to have_current_path metrics_path

      plot_is_populated('#affiliates-barchart-plot')
      within(:css, '#affiliates-barchart-title') { expect(page).to have_content 'Affiliate Product Additions By Category (Total: 1)' }
    end

    specify 'If there are affiliate product views' do
      product = FactoryBot.create(:product, business_id: 1)
      customer = FactoryBot.create(:customer)
      AffiliateProductView.new(product_id: product.id, customer_id: customer.id).save

      visit metrics_path
      expect(page).to have_current_path metrics_path

      plot_is_populated('#affiliate-views-linechart-plot')
      within(:css, '#affiliate-views-linechart-title') { expect(page).to have_content 'Affiliate Product Views Over Time (Total: 1)' }
    end
  end

  context 'Security' do
    specify 'If I am not logged in, I cannot view metrics' do
      visit metrics_path
      click_on(class: 'dropdown-toggle')
      within(:css, '.dropdown-menu') { expect(page).not_to have_content 'View Metrics' }
      expect(page).not_to have_content 'Metrics Summary'
      expect(page).to have_current_path new_staff_session_path
    end

    context 'If I am an admin' do
      before { login_as(FactoryBot.create(:admin), scope: :staff) }
      specify 'I can view metrics' do
        visit metrics_path
        click_on(class: 'dropdown-toggle')
        within(:css, '.dropdown-menu') { expect(page).to have_text 'View Metrics' }
        expect(page).to have_content 'Metrics Summary'
      end
    end

    context 'If I am an reporter' do
      before { login_as(FactoryBot.create(:reporter), scope: :staff) }
      specify 'I can view metrics' do
        visit metrics_path
        click_on(class: 'dropdown-toggle')
        within(:css, '.dropdown-menu') { expect(page).to have_content 'View Metrics' }
        expect(page).to have_content 'Metrics Summary'
      end
    end

    context 'If I am not an admin or reporter' do
      before { login_as(FactoryBot.create(:customer), scope: :customer) }
      specify ', I cannot view metrics' do
        visit metrics_path
        click_on(class: 'dropdown-toggle')
        within(:css, '.dropdown-menu') { expect(page).not_to have_content 'View Metrics' }
        expect(page).not_to have_content 'Metrics Summary'
      end
    end
  end
end
