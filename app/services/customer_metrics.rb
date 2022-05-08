# frozen_string_literal: true

# Calculates customer based metrics for use and display in the customer dashboard.
# Inherits some methods from CalculateMetrics
class CustomerMetrics < CalculateMetrics
  class << self
    def site_mean_co2_per_purchase
      PurchaseHistory.joins(:product).average(:co2_produced).to_f.round(1)
    end

    def site_total_co2_saved
      customer_co2_saved = Customer.joins(:products, :categories)
                                   .group('customers.id')
                                   .select('SUM(categories.mean_co2 - products.co2_produced) / SQRT(COUNT(products))' \
                                           'AS co2_saved')
      customer_co2_saved.sum(&:co2_saved).round(2)
    end

    def site_total_co2_produced
      customer_totals = Customer.joins(:products).group(:customer_id).sum(:co2_produced)

      return 0 if customer_totals.size.zero?

      (customer_totals.values.sum / customer_totals.size).round(1)
    end

    def site_co2_saved
      customer_co2_saved = Customer.joins(:products, :categories)
                                   .group('customers.id')
                                   .select('SUM(categories.mean_co2 - products.co2_produced) / SQRT(COUNT(products))' \
                                           'AS co2_saved')

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

    def time_co2_per_purchase(customer, period = :day)
      Customer.where(id: customer.id)
              .joins(:products)
              .group_by_period(period, 'purchase_histories.created_at', expand_range: true)
              .average(:co2_produced)
    end

    def time_total_co2(customer, period = :day)
      Customer.where(id: customer.id)
              .joins(:products)
              .group_by_period(period, 'purchase_histories.created_at', expand_range: true)
              .sum(:co2_produced)
    end

    def time_total_price(customer, period = :day)
      Customer.where(id: customer.id)
              .joins(:products)
              .group_by_period(period, 'purchase_histories.created_at', expand_range: true)
              .sum(:price)
    end

    def category_mean_co2_per_day(customer, period = :day)
      Customer.where(id: customer.id)
              .joins(:categories)
              .group_by_period(period, 'purchase_histories.created_at', expand_range: true)
              .sum(:mean_co2)
    end

    def product_co2_produced_per_day(customer, period = :day)
      Customer.where(id: customer.id)
              .joins(:products)
              .group_by_period(period, 'purchase_histories.created_at', expand_range: true)
              .sum(:co2_produced)
    end

    def time_co2_saved(customer)
      category_mean_co2_per_day(customer).map do |time, mean_co2|
        [time, mean_co2 - product_co2_produced_per_day(customer)[time]]
      end
    end

    def time_co2_per_pound(customer)
      time_total_co2(customer).map do |time, co2_produced|
        [time, co2_produced / (time_total_price(customer)[time].nonzero? || 1)]
      end
    end

    def time_products_added(customer, period = :day)
      Customer.where(id: customer.id)
              .joins(:products)
              .group_by_period(period, 'purchase_histories.created_at', expand_range: true)
              .count
    end
  end
end
