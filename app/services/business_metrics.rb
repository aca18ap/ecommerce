# frozen_string_literal: true

# Calculates business based metrics for use and display in the business dashboard.
# Inherits some methods from CalculateMetrics
class BusinessMetrics < CalculateMetrics
  class << self
    def time_affiliate_views(business)
      insert_zero_entries(
        Product.joins(:affiliate_product_views)
               .where(business_id: business.id)
               .group("date_trunc('day', affiliate_product_views.created_at)")
               .count
               .transform_keys(&:to_i)
      )
    end

    def views_by_product(business)
      Product.joins(:affiliate_product_views)
             .where(business_id: business.id)
             .group('affiliate_product_views.product_id', 'products.name')
             .select('COUNT(affiliate_product_views.product_id) AS count, products.name AS product_name,' \
                     'affiliate_product_views.product_id as product_id')
             .map { |product| { 'name' => "#{product.product_name} (#{product.product_id})", 'count' => product.count } }
    end

    def views_by_category(business)
      Product.joins(:affiliate_product_views)
             .where(business_id: business.id)
             .group('products.category')
             .count
             .map { |category, count| { 'category' => category, 'count' => count } }
    end
  end
end
