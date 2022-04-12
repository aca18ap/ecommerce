# frozen_string_literal: true

# CalculateMetrics calculates the points to represent on the
# D3 graphs represented on metrics/index
class CalculateMetrics
  class << self
    # Calculates the number of visits for each page
    def page_visits(visits_arr)
      return if visits_arr.nil? || visits_arr.empty?

      # { page: page_path, visits: num_visits }
      visits_arr.group_by { |visit| visit.path.itself }
                .map { |path, visits| { 'page' => path, 'visits' => visits.length } }
    end

    # Calculates the number of registrations for each vocation
    def vocation_registrations(registrations_arr)
      return if registrations_arr.nil? || registrations_arr.empty?

      # { vocation: vocation_type, registrations: num_registrations }
      registrations_arr.group_by { |registration| registration.vocation.itself }
                       .map do |vocation, registrations|
        { 'vocation' => vocation, 'registrations' => registrations.length }
      end
    end

    # Calculates all pages visited using a specific session cookie in order of time to build a site path
    def session_flows(visits_arr)
      return if visits_arr.nil? || visits_arr.empty?

      # { id: session_id, flow: [page_visit_objects], registered: whether_path_included_registration }
      visits_arr.group_by { |visit| visit.session_identifier.itself }
                .map do |session_id, visits|
        { 'id' => session_id, 'flow' => visits, 'registered' => flow_contains_registration?(visits) }
      end
    end

    # Calculates number of visits at each hour from the hour of the first visit
    def time_visits(visits_arr)
      return if visits_arr.nil? || visits_arr.empty?

      time_visit_counts = calculate_time_counts(visits_arr)

      # { time: time_by_hour, visits: num_visits_at_hour }
      time_visit_counts.map { |time, visits| { 'time' => time, 'visits' => visits } }
    end

    # Calculates number of registrations at each hour, for each vocation and total from the hour of the first
    # registration
    def time_registrations(registrations_arr)
      return if registrations_arr.nil? || registrations_arr.empty?

      time_regs = calculate_time_counts(registrations_arr)
                  .map { |time, regs| { 'vocation' => 'total', 'time' => time, 'registrations' => regs } }

      registrations_arr.group_by { |registration| registration.vocation.itself }.each do |vocation, registrations|
        time_regs.concat(calculate_time_counts(registrations)
                           .map { |time, regs| { 'vocation' => vocation, 'time' => time, 'registrations' => regs } })
      end

      # { time: time_by_hour, registrations: num_registrations_at_hour }
      time_regs
    end

    # Calculates the number of times each feature was shared to social media site
    def feature_shares(shares_arr)
      return if shares_arr.nil? || shares_arr.empty?

      # { feature: feature, social: social_type, count: num_social_shares_for_feature }
      shares_arr.group_by { |share| [share.feature, share.social] }
                .map { |feature, shares| { 'feature' => feature[0], 'social' => feature[1], 'count' => shares.length } }
    end

    # Calculates number of product entries over time
    def time_products(products_arr)
      return if products_arr.nil? || products_arr.empty?

      time_product_counts = calculate_time_counts(products_arr)

      # { time: time_by_hour, products: num_products_at_hour }
      time_product_counts.map { |time, products| { 'time' => time, 'products' => products } }
    end

    # Calculates the number of products in each category
    def product_categories
      Product.group(:category).count.map { |category, count| { 'category' => category, 'products' => count } }
    end

    # Calculates the number of affiliate products in each category
    def affiliate_product_categories
      Product.where.not(business_id: nil)
             .group(:category).count.map { |category, count| { 'category' => category, 'products' => count } }
    end

    # Calculates the number of affiliate product views over time
    def time_affiliate_views
      insert_zero_entries(
        AffiliateProductView.group("date_trunc('hour', created_at)").count.transform_keys(&:to_i), 'hour'
      )
    end

    private

    # Calculates the number of elements in an array that occur at each hour between a start and end time
    # TODO Deprecate
    def calculate_time_counts(element_array)
      time_counts = {}

      # Need to create a dict of all hours between start and now to display 0 values correctly
      earliest_hour = element_array.first.hour
      latest_hour = DateTime.now.change({ min: 0, sec: 0 })
      (earliest_hour.to_i..latest_hour.to_i).step(1.hour) do |date|
        time_counts[date] = 0
      end

      element_array.each do |element|
        time_counts[element.hour.to_i] += 1
      end

      time_counts
    end

    # Inserts 0 entries for intervals of time which don't have any data
    def insert_zero_entries(data_hash, step = 'day')
      return if data_hash.nil? || data_hash.empty?

      step_size = if step == 'day'
                    1.day
                  else
                    1.hour
                  end

      earliest_day = data_hash.first[0]
      latest_day = (Time.now + 1.day).change({ hour: 0, min: 0, sec: 0 })

      data_arr = []
      (earliest_day.to_i..latest_day.to_i).step(step_size) do |date|
        data_arr.append({ 'time' => date, 'value' => data_hash.key?(date) ? data_hash[date] : 0 })
      end

      data_arr
    end

    # Identifies whether a session led to a registration by checking for /newsletters/# in path
    # TODO: update to use signups instead of newsletters
    def flow_contains_registration?(flow)
      flow.each do |f|
        return true if f.path.match(%r{.*/newsletters/[0-9]+})
      end

      false
    end
  end
end
