# frozen_string_literal: true

require 'rails_helper'

describe 'Customer metrics' do
  let!(:product) { FactoryBot.create(:product, created_at: Time.now.change({ sec: 0 }) - 2.days) }
  let!(:product2) { FactoryBot.create(:product, url: 'https://anotherwebsite.com', price: 5.7, created_at: Time.now.change({ sec: 0 })) }
  let!(:customer) { FactoryBot.create(:customer) }

  def insert_purchases(product_id, customer_id, created_at)
    purchase = PurchaseHistory.new(product_id: product_id, customer_id: customer_id, created_at: created_at)
    purchase.save
    purchase
  end

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
        customer.products << product
        customer.products << product2

        expected_sum = ((product.category.mean_co2 - product.co2_produced) + (product2.category.mean_co2 - product2.co2_produced)).round(1)
        expect(CustomerMetrics.site_co2_saved).to eq expected_sum
      end
    end

    describe '.site_total_co2_saved' do
      it 'returns the total co2 saved across all users' do
        customer.products << product
        customer.products << product2
        expected_total = ((product.category.mean_co2 - product.co2_produced) + (product2.category.mean_co2 - product2.co2_produced)).round(2)
        expect(CustomerMetrics.site_total_co2_saved).to eq expected_total
      end
    end

    describe '.plane_journeys_saved' do
      it 'returns the plane journeys equivalent of CO2 saved by the website' do
        customer.products << product
        customer.products << product2
        expected_journeys = (((product.category.mean_co2 - product.co2_produced) + (product2.category.mean_co2 - product2.co2_produced)).to_f / 590).round(2)
        expect(CustomerMetrics.plane_journeys_saved).to eq expected_journeys
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
        expect(CustomerMetrics.time_co2_per_purchase(customer)).to eq({})
      end

      def test_co2_purchases
        insert_purchases(product.id, customer.id, (Date.today - 2.days))
        insert_purchases(product2.id, customer.id, Date.today)

        # Need to cast calculated averages to float to allow rspec to match in array https://github.com/rspec/rspec-core/issues/2383
        results = CustomerMetrics.time_co2_per_purchase(customer)
        results = results.map { |r| [r[0], r[1].to_f] }

        expect(results).to match_array(
          [[Date.today - 2.days, product.co2_produced],
           [Date.today - 1.day, 0],
           [Date.today, product2.co2_produced]]
        )
      end

      it 'returns the correct average co2 per purchase per day for a customer if there are purchases in the morning' do
        travel_to Time.zone.local(2022, 0o5, 0o5, 0o1, 0o0, 0o0)
        freeze_time
        test_co2_purchases
      end

      it 'returns the correct average co2 per purchase per day for a customer if there are purchases in the afternoon' do
        travel_to Time.zone.local(2022, 0o5, 0o5, 13, 0o0, 0o0)
        freeze_time
        test_co2_purchases
      end
    end

    describe '.time_total_co2' do
      it 'returns nil if there are no purchases for a customer' do
        expect(CustomerMetrics.time_total_co2(customer)).to eq({})
      end

      def test_co2_total
        purchase1 = insert_purchases(product.id, customer.id, (Time.now - 2.days))
        purchase2 = insert_purchases(product2.id, customer.id, Time.now)

        expect(CustomerMetrics.time_total_co2(customer)).to match_array(
          [[purchase1.created_at.change({ hour: 0, min: 0, sec: 0 }), product.co2_produced],
           [(purchase2.created_at.change({ hour: 0, min: 0, sec: 0 }) - 1.day), 0],
           [purchase2.created_at.change({ hour: 0, min: 0, sec: 0 }), product2.co2_produced]]
        )
      end

      it 'returns the correct total co2 produced per day for a customer if there are purchases in the morning' do
        travel_to Time.zone.local(2022, 0o5, 0o5, 0o1, 0o0, 0o0)
        freeze_time
        test_co2_total
      end

      it 'returns the correct total co2 produced per day for a customer if there are purchases in the afternoon' do
        travel_to Time.zone.local(2022, 0o5, 0o5, 13, 0o0, 0o0)
        freeze_time
        test_co2_total
      end
    end

    describe '.time_co2_saved' do
      it 'returns nil if there are no purchases for a customer' do
        expect(CustomerMetrics.time_co2_saved(customer)).to eq([])
      end

      def test_co2_saved
        purchase1 = insert_purchases(product.id, customer.id, (Time.now - 2.days))
        purchase2 = insert_purchases(product2.id, customer.id, Time.now)

        expect(CustomerMetrics.time_co2_saved(customer)).to match_array(
          [[purchase1.created_at.change({ hour: 0, min: 0, sec: 0 }), (product.category.mean_co2 - product.co2_produced)],
           [(purchase2.created_at.change({ hour: 0, min: 0, sec: 0 }) - 1.day), 0],
           [purchase2.created_at.change({ hour: 0, min: 0, sec: 0 }), (product.category.mean_co2 - product.co2_produced)]]
        )
      end

      it 'returns the correct total co2 produced per day for a customer if there are purchases in the morning' do
        travel_to Time.zone.local(2022, 0o5, 0o5, 0o1, 0o0, 0o0)
        freeze_time
        test_co2_saved
      end

      it 'returns the correct total co2 produced per day for a customer if there are purchases in the afternoon' do
        travel_to Time.zone.local(2022, 0o5, 0o5, 13, 0o0, 0o0)
        freeze_time
        test_co2_saved
      end
    end

    describe '.time_co2_per_pound' do
      it 'returns nil if there are no purchases for a customer' do
        expect(CustomerMetrics.time_co2_per_pound(customer)).to eq([])
      end

      def test_co2_per_pound
        purchase1 = insert_purchases(product.id, customer.id, (Time.now - 2.days))
        purchase2 = insert_purchases(product2.id, customer.id, Time.now)

        expect(CustomerMetrics.time_co2_per_pound(customer)).to match_array(
          [[purchase1.created_at.change({ hour: 0, min: 0, sec: 0 }), (product.co2_produced / product.price)],
           [(purchase2.created_at.change({ hour: 0, min: 0, sec: 0 }) - 1.day), 0],
           [purchase2.created_at.change({ hour: 0, min: 0, sec: 0 }), (product2.co2_produced / product2.price)]]
        )
      end

      it 'returns the correct co2 per pound metric per day for a customer if there are purchases in the morning' do
        travel_to Time.zone.local(2022, 0o5, 0o5, 0o1, 0o0, 0o0)
        freeze_time
        test_co2_per_pound
      end

      it 'returns the correct co2 per pound metric per day for a customer if there are purchases in the afternoon' do
        travel_to Time.zone.local(2022, 0o5, 0o5, 13, 0o0, 0o0)
        freeze_time
        test_co2_per_pound
      end
    end

    describe '.time_products_added' do
      it 'returns nil if there are no purchases for a customer' do
        expect(CustomerMetrics.time_products_added(customer)).to eq({})
      end

      def test_products_added
        purchase1 = insert_purchases(product.id, customer.id, (Time.now - 2.days))
        purchase2 = insert_purchases(product2.id, customer.id, Time.now)

        expect(CustomerMetrics.time_products_added(customer)).to match_array(
          [[purchase1.created_at.change({ hour: 0, min: 0, sec: 0 }), 1],
           [(purchase2.created_at.change({ hour: 0, min: 0, sec: 0 }) - 1.day), 0],
           [purchase2.created_at.change({ hour: 0, min: 0, sec: 0 }), 1]]
        )
      end

      it 'returns the correct number of products added per day for a customer if there are purchases in the morning' do
        travel_to Time.zone.local(2022, 0o5, 0o5, 0o1, 0o0, 0o0)
        freeze_time
        test_products_added
      end

      it 'returns the correct number of products added per day for a customer if there are purchases in the afternoon' do
        travel_to Time.zone.local(2022, 0o5, 0o5, 13, 0o0, 0o0)
        freeze_time
        test_products_added
      end
    end
  end
end
