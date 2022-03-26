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

      customer_totals.values.sum / customer_totals.size
    end

    def site_co2_saved
      # TODO: Implement function
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
      Customer.where(id: customer.id)
              .joins(:products)
              .group("date_trunc('day', products.created_at)")
              .average(:co2_produced)
    end

    def time_total_co2(customer)
      Customer.where(id: customer.id)
              .joins(:products)
              .group("date_trunc('day', products.created_at)")
              .sum(:co2_produced)
    end

    def time_co2_saved(customer)
      # TODO: Implement function
      {}
    end

    def time_co2_per_pound(customer)
      # TODO: Come back and work out how to maintain date
      Customer.where(id: customer.id)
              .joins(:products)
              .group("date_trunc('hour', products.created_at)")
              .select('SUM(products.co2_produced) / SUM(products.price)')
    end

    def time_products_total(customer)
      Customer.where(id: customer.id).joins(:products).group("date_trunc('hour', products.created_at)").count
    end
  end
end
