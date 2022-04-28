# frozen_string_literal: true

require 'rails_helper'

describe 'Products' do
  let!(:customer) { FactoryBot.create(:customer) }
  let!(:product) { FactoryBot.create(:product) }
  before { login_as(customer, scope: :customer) }

  context 'If there are purchases in my history' do
    before { customer.products << product }

    specify 'I can see a list of them on my dashboard' do
      visit root_path
      expect(page).to have_content product.name
    end

    specify 'I can remove products from my purchase history', js: true do
      visit root_path
      expect(customer.products.count).to eq 1

      accept_confirm do
        find('.delete_product').click
      end

      expect(page).to_not have_content product.name
      expect(customer.products.reload.count).to eq 0
    end
  end
end
