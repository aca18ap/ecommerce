# frozen_string_literal: true

# CalculateMetrics calculates the points to represent on the
# D3 graphs represented on metrics/index
class CalculateMetrics
  class << self
    def product_categories
      Category.joins(:products).group(:name).count
    end

    def time_product_additions(period = :day)
      Product.group_by_period(period, :created_at, expand_range: true).count
    end

    def affiliate_categories
      Product.where.not(business_id: nil).joins(:category).group('categories.name').count
    end

    def time_affiliate_views(period = :day)
      AffiliateProductView.group_by_period(period, :created_at, expand_range: true).count
    end

    def visits_by_page
      Visit.group(:path).count
    end

    def time_visits(period = :day)
      Visit.group_by_period(period, :from, expand_range: true).count
    end

    def vocation_registrations
      Registration.group(:vocation).count
    end

    def time_registrations(period = :day)
      Registration.group_by_period(period, :created_at, expand_range: true).count
    end

    def feature_interest
      Share.group(:feature, :social).count
    end

    def session_flows
      Visit.select(:session_identifier, :from, :to, :path).group_by(&:session_identifier).map do |session, visits|
        { session => visits.map { |visit| { 'path' => visit.path, 'duration' => visit.to - visit.from } } }
      end
    end

    private

    # Identifies whether a session led to a registration by checking for /newsletters/# in path
    def flow_contains_registration?(flow)
      flow.each do |f|
        return true if f.path.match(%r{.*/newsletters/[0-9]+})
      end

      false
    end
  end
end
