# frozen_string_literal: true

require 'rails_helper'

describe 'Metrics management', js: true do
  def plot_is_empty(css_id)
    within(:css, css_id) { expect(page).to have_content 'There is no data for this metric yet' }
  end

  def plot_is_populated(css_id)
    within(:css, css_id) { expect(page).to_not have_content 'There is no data for this metric yet' }
  end

  context 'If there are no purchases for a customer' do
    before { login_as(FactoryBot.create(:customer), scope: :customer) }

    specify 'The graphs should show an appropriate message' do
      visit authenticated_customer_root_path

      within(:css, '#avg-co2-stat') { expect(page).to have_content 'N/AKg' }
      within(:css, '#total-co2-stat') { expect(page).to have_content 'N/AKg' }
      within(:css, '#co2-saved-stat') { expect(page).to have_content 'N/AKg' }
      within(:css, '#co2-per-pound-stat') { expect(page).to have_content 'N/AKg' }
      within(:css, '#total-purchases-stat') { expect(page).to have_content '0' }

      plot_is_empty('#co2-purchased-graph')
      find('#open-total-co2-tab').click
      plot_is_empty('#total-co2-graph')
      find('#open-co2-saved-tab').click
      plot_is_empty('#co2-saved-graph')
      find('#open-co2-pound-tab').click
      plot_is_empty('#co2-pound-graph')
      find('#open-products-added-tab').click
      plot_is_empty('#products-added-graph')
    end
  end

  context 'If there are purchases for a customer' do
    let!(:customer) { FactoryBot.create(:customer) }
    let!(:product) { FactoryBot.create(:product, created_at: '2021-11-27 16:39:22') }

    before do
      login_as(customer, scope: :customer)
      customer.products << product
      visit authenticated_customer_root_path
    end

    specify 'the graphs display the data' do
      within(:css, '#avg-co2-stat') { expect(page).to have_content "#{product.co2_produced.round(1)}Kg" }
      within(:css, '#total-co2-stat') { expect(page).to have_content "#{product.co2_produced.round(1)}Kg" }
      # within(:css, '#co2-saved-stat') { expect(page).to have_content 'N/AKg' }
      within(:css, '#co2-per-pound-stat') { expect(page).to have_content "#{(product.co2_produced / product.price).round(1)}Kg" }
      within(:css, '#total-purchases-stat') { expect(page).to have_content '1' }

      plot_is_populated('#co2-purchased-graph')
      find('#open-total-co2-tab').click
      plot_is_populated('#total-co2-graph')
      find('#open-co2-saved-tab').click
      # plot_is_populated('#co2-saved-graph')
      find('#open-co2-pound-tab').click
      plot_is_populated('#co2-pound-graph')
      find('#open-products-added-tab').click
      plot_is_populated('#products-added-graph')
    end
  end
end
