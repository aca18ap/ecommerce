# frozen_string_literal: true

# Calculates customer based metrics for use and display in the customer dashboard.
# Inherits some methods from CalculateMetrics
class CustomerMetrics < CalculateMetrics
  class << self
    def site_mean_co2_per_purchase
      PurchaseHistory.joins(:product).average(:co2_produced).to_f.round(1)
    end

    def site_total_co2_produced
      customer_totals = Customer.joins(:products).group(:customer_id).sum(:co2_produced)

      return 0 if customer_totals.size.zero?

      (customer_totals.values.sum / customer_totals.size).round(1)
    end

    def site_co2_saved
      0
    end

    def site_co2_per_pound
      PurchaseHistory.joins(:product).pluck(Arel.sql('sum(co2_produced) / sum(price)')).first.to_f.round(1)
    end

    def site_products_total
      customer_products = Customer.joins(:products).group(:customer_id).count

      return 0 if customer_products.size.zero?

      customer_products.values.sum / customer_products.size
    end

    def time_co2_per_purchase(customer)
      insert_zero_entries(
        Customer.where(id: customer.id)
                .joins(:products)
                .group("date_trunc('day', products.created_at)")
                .average(:co2_produced)
                .transform_keys(&:to_i)
                .transform_values { |average| average.round(1) }
      )
    end

    def time_total_co2(customer)
      insert_zero_entries(
        Customer.where(id: customer.id)
                .joins(:products)
                .group("date_trunc('day', products.created_at)")
                .sum(:co2_produced)
                .transform_keys(&:to_i)
                .transform_values { |average| average.round(1) }
      )
    end

    def time_co2_saved(_customer)
      insert_zero_entries([])
    end

    def time_co2_per_pound(customer)
      insert_zero_entries(
        Customer.where(id: customer.id)
                .joins(:products)
                .group("date_trunc('day', products.created_at)")
                .select("date_trunc('day', products.created_at) AS day," \
                        'SUM(products.co2_produced) / SUM(products.price) AS co2_per_pound')
                .map { |day| { day.day.to_i => day.co2_per_pound.round(1) } }
                .reduce({}, :update)
      )
    end

    def time_products_total(customer)
      insert_zero_entries(
        Customer.where(id: customer.id).joins(:products)
                .group("date_trunc('day', products.created_at)")
                .count
                .transform_keys(&:to_i)
      )
    end

    private

    # Inserts 0 entries for intervals of time which don't have any data
    def insert_zero_entries(data_hash)
      return if data_hash.nil? || data_hash.empty?

      earliest_day = data_hash.first[0]
      latest_day = (Time.now + 1.day).change({ hour: 0, min: 0, sec: 0 })

      data_arr = []
      (earliest_day.to_i..latest_day.to_i).step(1.day) do |date|
        data_arr.append({ 'time' => date, 'value' => data_hash.key?(date) ? data_hash[date] : 0 })
      end

      data_arr
    end
  end
end
