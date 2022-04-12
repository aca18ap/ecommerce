# frozen_string_literal: true

require 'rails_helper'

describe 'Calculating metrics' do
  let!(:product) { FactoryBot.create(:product, created_at: Time.now.change({ sec: 0 }) - 2.days) }
  let!(:product2) { FactoryBot.create(:product, url: 'https://anotherwebsite.com', price: 5.7, created_at: Time.now.change({ sec: 0 })) }
  let!(:customer) { FactoryBot.create(:customer) }

  describe 'Site wide statistics' do
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
  end

  describe 'Time based metrics for a customer' do
    describe '.time_co2_per_purchase' do
      it 'returns nil if there are no purchases for a customer' do
        expect(CustomerMetrics.time_co2_per_purchase(customer)).to eq nil
      end

      it 'returns the average co2 per purchase per day for a customer if there are purchases' do
        customer.products << product
        customer.products << product2

        expect(CustomerMetrics.time_co2_per_purchase(customer)).to match_array(
          [{ 'time' => product.created_at.change({ hour: 0, min: 0, sec: 0 }).to_i, 'value' => product.co2_produced.round(1) },
           { 'time' => (product2.created_at.change({ hour: 0, min: 0, sec: 0 }) - 1.day).to_i, 'value' => 0 },
           { 'time' => product2.created_at.change({ hour: 0, min: 0, sec: 0 }).to_i, 'value' => product2.co2_produced.round(1) }]
        )
      end
    end

    describe '.time_total_co2' do
      it 'returns nil if there are no purchases for a customer' do
        expect(CustomerMetrics.time_total_co2(customer)).to eq nil
      end

      it 'returns the total co2 produced per day for a customer if there are purchases' do
        customer.products << product
        customer.products << product2

        expect(CustomerMetrics.time_total_co2(customer)).to match_array(
          [{ 'time' => product.created_at.change({ hour: 0, min: 0, sec: 0 }).to_i, 'value' => product.co2_produced.round(1) },
           { 'time' => (product2.created_at.change({ hour: 0, min: 0, sec: 0 }) - 1.day).to_i, 'value' => 0 },
           { 'time' => product2.created_at.change({ hour: 0, min: 0, sec: 0 }).to_i, 'value' => product2.co2_produced.round(1) }]
        )
      end
    end

    describe '.time_co2_saved' do
      it 'returns nil if there are no purchases for a customer' do
        expect(CustomerMetrics.time_co2_saved(customer)).to eq nil
      end

      it 'returns the total co2 produced per day for a customer if there are purchases' do
        customer.products << product
        customer.products << product2

        skip 'awaiting implementation'
      end
    end

    describe '.time_co2_per_pound' do
      it 'returns nil if there are no purchases for a customer' do
        expect(CustomerMetrics.time_co2_per_pound(customer)).to eq nil
      end

      it 'returns the co2 per pound metric per day for a customer if there are purchases' do
        customer.products << product
        customer.products << product2

        expect(CustomerMetrics.time_co2_per_pound(customer)).to match_array(
          [{ 'time' => product.created_at.change({ hour: 0, min: 0, sec: 0 }).to_i, 'value' => (product.co2_produced / product.price).round(1) },
           { 'time' => (product2.created_at.change({ hour: 0, min: 0, sec: 0 }) - 1.day).to_i, 'value' => 0 },
           { 'time' => product2.created_at.change({ hour: 0, min: 0, sec: 0 }).to_i, 'value' => (product2.co2_produced / product2.price).round(1) }]
        )
      end
    end

    describe '.time_products_total' do
      it 'returns nil if there are no purchases for a customer' do
        expect(CustomerMetrics.time_products_total(customer)).to eq nil
      end

      it 'returns the number of products added per day for a customer if there are purchases' do
        customer.products << product
        customer.products << product2

        expect(CustomerMetrics.time_products_total(customer)).to match_array(
          [{ 'time' => product.created_at.change({ hour: 0, min: 0, sec: 0 }).to_i, 'value' => 1 },
           { 'time' => (product2.created_at.change({ hour: 0, min: 0, sec: 0 }) - 1.day).to_i, 'value' => 0 },
           { 'time' => product2.created_at.change({ hour: 0, min: 0, sec: 0 }).to_i, 'value' => 1 }]
        )
      end
    end

    describe '.insert_zero_entries' do
      it 'returns nil if nil or an empty array is passed' do
        expect(CustomerMetrics.send(:insert_zero_entries, [])).to eq nil
        expect(CustomerMetrics.send(:insert_zero_entries, nil)).to eq nil
      end
    end
  end
end
