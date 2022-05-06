# frozen_string_literal: true

# Handles the end points for metrics graphs to improve page load times on metrics page
class MetricsGraphsController < StaffsController
  def product_categories_chart
    render json: Category.joins(:products).group(:name).count
  end

  def time_product_additions_chart
    render json: Product.group_by_period(:day, :created_at, expand_range: true).count
  end

  def affiliate_categories_chart
    render json: Product.where.not(business_id: nil).joins(:category).group('categories.name').count
  end

  def time_affiliate_views_chart
    render json: Product.where.not(business_id: nil).group_by_period(:day, :created_at, expand_range: true).count
  end

  def visits_by_page_chart
    render json: Visit.group(:path).count
  end

  def time_visits_chart
    render json: Visit.group_by_period(:day, :from, expand_range: true).count
  end

  def vocation_registrations_chart
    render json: Registration.group(:vocation).count
  end

  def time_registrations_chart
    render json: Registration.group_by_period(:day, :created_at, expand_range: true).count
  end

  def feature_interest_chart
    render json: Share.group(:feature).count
  end
end
