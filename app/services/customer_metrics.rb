
class CustomerMetrics < CalculateMetrics
  class << self
    def site_mean_co2_per_purchase
      PurchaseHistory.joins(:product).average(:co2_produced).round(1)
    end

    def site_total_co2_produced
      customer_totals = Customer.joins(:products).group(:customer_id).sum(:co2_produced)
      customer_totals.values.sum / customer_totals.size
    end

    def site_co2_saved
      # TODO: Implement function
      0
    end

    def site_co2_per_pound
      PurchaseHistory.joins(:product).pluck(Arel.sql('sum(co2_produced) / sum(price)')).first.round(1)
    end

    def site_products_total
      customer_products = Customer.joins(:products).group(:customer_id).count
      customer_products.values.sum / customer_products.size
    end
  end
end
