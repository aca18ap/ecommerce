# frozen_string_literal: true

# Calculates business based metrics for use and display in the business dashboard.
# Inherits some methods from CalculateMetrics
class BusinessMetrics < CalculateMetrics
  class << self
    def time_affiliate_views(business, period = :day)
      Product.joins(:affiliate_product_views)
             .where(business_id: business.id)
             .group_by_period(period, 'affiliate_product_views.created_at')
             .count
    end

    def views_by_product(business)
      Product.joins(:affiliate_product_views).where(business_id: business.id).group('products.name').count
    end

    def views_by_category(business)
      Product.joins(:affiliate_product_views, :category).where(business_id: business.id).group('categories.name').count
    end
  end
end
