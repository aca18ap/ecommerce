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

  describe 'POST /create' do
    let!(:valid_attributes) do
      { created_at: Time.now - 1.day, product_id: product.id }
    end

    it 'returns a successful response if the request was valid' do
      login_as(customer, scope: :customer)
      expect(customer.products.size).to eq 0

      post purchase_histories_path, params: { purchase_history: valid_attributes }
      expect(response).to be_successful

      expect(customer.products.reload.size).to eq 1
      expect(PurchaseHistory.first.created_at.utc).to be_within(1.second).of valid_attributes[:created_at]
    end

    it 'returns an error if the current logged in user is not a customer' do
      expect(customer.products.size).to eq 0

      post purchase_histories_path, params: { purchase_history: valid_attributes }
      expect(response).to_not be_successful

      expect(customer.products.reload.size).to eq 0
    end
  end
end
