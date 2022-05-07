# frozen_string_literal: true

require 'rails_helper'

# Unintended behaviour which prevents affiliate products from being deleted if they exist in a customer's purchase history
describe 'Regression testing of delete affiliate products bug', type: :request do
  let!(:business) { FactoryBot.create(:business) }
  let!(:product) { FactoryBot.create(:product, business_id: business.id) }
  before { login_as(business, scope: :business) }

  context 'If my product has not been purchased by any customer' do
    it 'can be deleted' do
      delete product_url(product)
      expect(response).to be_successful
    end
  end

  context 'If my product has been purchased by a customer' do
    let(:customer) { FactoryBot.create(:customer) }

    it 'can be deleted' do
      customer.products << product

      delete product_url(product)
      expect(response).to be_successful
    end
  end
end
