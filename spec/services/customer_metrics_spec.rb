# frozen_string_literal: true

require 'rails_helper'

describe 'Calculating metrics' do
  let!(:product) { FactoryBot.create(:product) }
  let!(:product2) { FactoryBot.create(:product, url: 'https://anotherwebsite.com', price: 5.7) }
  let!(:customer) { FactoryBot.create(:customer) }

  describe '.site_mean_co2_per_purchase' do
    it 'returns 0 if there are no purchases' do
      expect(CustomerMetrics.site_mean_co2_per_purchase).to eq 0
    end

    it 'returns the mean co2 per purchase across the site if purchases exist' do
      customer.products << product
      customer.products << product2

      expected_mean = (product.co2_produced + product2.co2_produced) / 2
      expect(CustomerMetrics.site_mean_co2_per_purchase).to eq expected_mean.round(1)
    end
  end

  describe '.site_total_co2_produced' do
    it 'returns 0 if there are no entries in the product history table' do
      expect(CustomerMetrics.site_total_co2_produced).to eq 0
    end

    it 'returns the total co2 produced across the site if purchases exist' do
      customer.products << product
      customer.products << product2

      expected_sum = product.co2_produced + product2.co2_produced
      expect(CustomerMetrics.site_total_co2_produced).to eq expected_sum.round(1)
    end
  end

  describe '.site_co2_saved' do
    it 'returns 0 if there are no entries in the product history table' do
      expect(CustomerMetrics.site_co2_saved).to eq 0
    end

    it 'returns the total co2 saved across the site if purchases exist' do
      skip 'awaiting implementation'
    end
  end

  describe '.site_co2_per_pound' do
    it 'returns 0 if there are no entries in the product history table' do
      expect(CustomerMetrics.site_co2_per_pound).to eq 0
    end

    it 'returns the co2 produced per pound across the site if purchases exist' do
      customer.products << product
      customer.products << product2

      expected_sum = ((product.co2_produced + product2.co2_produced) / (product.price + product2.price)).round(1)
      expect(CustomerMetrics.site_co2_per_pound).to eq expected_sum
    end
  end

  describe '.site_products_total' do
    it 'returns 0 if there are no entries in the product history table' do
      expect(CustomerMetrics.site_products_total).to eq 0
    end

    it 'returns the number of purchases across the site if purchases exist' do
      customer.products << product
      customer.products << product2

      expect(CustomerMetrics.site_products_total).to eq 2
    end
  end

  describe '.time_co2_per_purchase' do
    skip 'awaiting implementation'
  end

  describe '.time_total_co2' do
    skip 'awaiting implementation'
  end

  describe '.time_co2_saved' do
    skip 'awaiting implementation'
  end

  describe '.time_co2_per_pound' do
    skip 'awaiting implementation'
  end

  describe '.time_products_total' do
    skip 'awaiting implementation'
  end
end
