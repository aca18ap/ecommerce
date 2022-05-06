# frozen_string_literal: true

require 'rails_helper'

describe 'Business Metrics Graphs', js: true do
  let!(:business) { FactoryBot.create(:business).decorate }
  before { login_as(business, scope: :business) }

  def plot_is_empty(css_id)
    within(:css, css_id) { expect(page).to have_content 'No data' }
  end

  def plot_is_populated(css_id)
    within(:css, css_id) { expect(page).to_not have_content 'No data' }
  end

  context 'If there are no products for a business' do
    specify 'The graphs should show an appropriate message' do
      visit dashboard_path

      within(:css, '#total-views-stat') { expect(page).to have_content '0' }
      within(:css, '#customer-purchases-stat') { expect(page).to have_content '0' }
      within(:css, '#affiliate-products-stat') { expect(page).to have_content '0' }
      within(:css, '#unique-categories-stat') { expect(page).to have_content '0' }

      plot_is_empty('#total-product-views-graph')
      find('#open-product-views-tab').click
      plot_is_empty('#product-views-graph')
      find('#open-category-views-tab').click
      plot_is_empty('#category-views-graph')
    end
  end

  context 'If there are affiliate products' do
    let!(:product) { FactoryBot.create(:product, business_id: business.id) }
    let(:customer) { FactoryBot.create(:customer) }

    specify 'the appropriate page statistics should update' do
      visit dashboard_path
      within(:css, '#affiliate-products-stat') { expect(page).to have_content '1' }
      within(:css, '#unique-categories-stat') { expect(page).to have_content '1' }
    end

    context 'If there are affiliate views' do
      specify 'the appropriate page statistics anf graphs should update' do
        AffiliateProductView.new(product_id: product.id, customer_id: customer.id).save
        visit dashboard_path

        within(:css, '#total-views-stat') { expect(page).to have_content '1' }
        plot_is_populated('#total-product-views-graph')
        find('#open-product-views-tab').click
        plot_is_populated('#product-views-graph')
        find('#open-category-views-tab').click
        plot_is_populated('#category-views-graph')
      end
    end

    context 'If there are customer purchases of affiliate products' do
      specify 'the appropriate page statistics should update' do
        customer.products << product
        visit dashboard_path

        within(:css, '#customer-purchases-stat') { expect(page).to have_content '1' }
      end
    end
  end
end
