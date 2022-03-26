# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomerDecorator do
  let(:customer) { FactoryBot.create(:customer).decorate }
  let!(:product) { FactoryBot.create(:product, co2_produced: 2.44) }

  describe '.unlock_button?' do
    context 'when a customer is locked through devise' do
      it 'should return a button to unlock their account' do
        customer.lock_access!
        expect(customer.unlock_button?).to have_link 'Unlock'
      end
    end

    context 'when a customer is not locked through devise' do
      it 'should return nothing' do
        expect(customer.unlock_button?).not_to have_link 'Unlock'
      end
    end
  end

  describe '.mean_co2_per_purchase' do
    it 'returns "N/A" if a customer has no products in their purchase history' do
      expect(customer.mean_co2_per_purchase).to be 'N/A'
    end

    it 'returns the mean CO2, rounded to one decimal place if there are purchases in their history' do
      customer.products << product
      customer.products << product

      expected_mean = product.co2_produced.round(1)
      expect(customer.mean_co2_per_purchase).to be expected_mean
    end
  end

  describe '.total_co2_produced' do
    it 'returns "N/A" if a customer has no products in their purchase history' do
      expect(customer.total_co2_produced).to be 'N/A'
    end

    it 'returns the total CO2, rounded to one decimal place if there are purchases in their history' do
      customer.products << product
      customer.products << product

      expected_mean = (2 * product.co2_produced).round(1)
      expect(customer.total_co2_produced).to be expected_mean
    end
  end

  describe '.co2_saved' do
    it 'returns "N/A" if a customer has no products in their purchase history' do
      expect(customer.total_co2_produced).to be 'N/A'
    end

    it 'returns the total CO2 saved, rounded to one decimal place if there are purchases in their history' do
      skip 'Needs implementing'
    end
  end

  describe '.co2_per_pound' do
    it 'returns "N/A" if a customer has no products in their purchase history' do
      expect(customer.total_co2_produced).to be 'N/A'
    end

    it 'returns the CO2 per pound, rounded to one decimal place if there are purchases in their history' do
      customer.products << product
      customer.products << product

      expect(customer.co2_per_pound).to eq(product.co2_produced / product.price)
    end
  end
end
