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
      customer_co2_saved = Customer.joins(:products, :categories)
                                   .group('customers.id')
                                   .select('SUM(categories.mean_co2 - products.co2_produced) AS co2_saved')

      return 0 if customer_co2_saved.length.zero?

      (customer_co2_saved.map(&:co2_saved).sum / customer_co2_saved.size).round(1)
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
                .group("date_trunc('day', purchase_histories.created_at)")
                .average(:co2_produced)
                .transform_keys(&:to_i)
                .transform_values { |average| average.round(1) }
      )
    end

    def time_total_co2(customer)
      insert_zero_entries(
        Customer.where(id: customer.id)
                .joins(:products)
                .group("date_trunc('day', purchase_histories.created_at)")
                .sum(:co2_produced)
                .transform_keys(&:to_i)
                .transform_values { |average| average.round(1) }
      )
    end

    def time_co2_saved(customer)
      insert_zero_entries(
        Customer.where(id: customer.id)
                .joins(:products, :categories)
                .group("date_trunc('day', purchase_histories.created_at)")
                .select("date_trunc('day', purchase_histories.created_at) AS day," \
                        'SUM(categories.mean_co2 - products.co2_produced) AS value')
                .map { |day| { day.day.to_i => day.value.round(1) } }
                .reduce({}, :update)
      )
    end

    def time_co2_per_pound(customer)
      insert_zero_entries(
        Customer.where(id: customer.id)
                .joins(:products)
                .group("date_trunc('day', purchase_histories.created_at)")
                .select("date_trunc('day', purchase_histories.created_at) AS day," \
                        'SUM(products.co2_produced) / SUM(products.price) AS co2_per_pound')
                .map { |day| { day.day.to_i => day.co2_per_pound.round(1) } }
                .reduce({}, :update)
      )
    end

    def time_products_total(customer)
      insert_zero_entries(
        Customer.where(id: customer.id).joins(:products)
                .group("date_trunc('day', purchase_histories.created_at)")
                .count
                .transform_keys(&:to_i)
      )
    end
  end
end
