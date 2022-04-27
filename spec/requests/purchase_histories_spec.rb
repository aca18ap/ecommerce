# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PurchaseHistories', type: :request do
  let!(:customer) { FactoryBot.create(:customer) }
  let!(:customer2) { FactoryBot.create(:customer, email: 'customer2@team04.com', username: 'new_username') }
  let!(:product) { FactoryBot.create(:product) }

  describe 'DELETE /destroy' do
    before { customer.products << product }

    it 'returns a successful response if the purchase was deleted' do
      login_as(customer, scope: :customer)

      expect(customer.products.size).to eq 1
      delete purchase_history_path(product)

      expect(response).to be_successful
      expect(customer.products.size).to eq 0
    end

    it 'returns an error if the current logged in user is not a customer' do
      expect(customer.products.size).to eq 1
      delete purchase_history_path(product)

      expect(response).to_not be_successful
      expect(customer.products.size).to eq 1
    end

    it 'returns an error if the purchase does not belong to the current user' do
      login_as(customer2, scope: :customer)

      expect(customer.products.size).to eq 1
      delete purchase_history_path(product)

      expect(response).to be_successful
      expect(customer.products.size).to eq 1
    end
  end
end
