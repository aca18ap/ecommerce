# frozen_string_literal: true

# Handles the end points for metrics graphs to improve page load times on metrics page
class MetricsGraphsController < StaffsController
  before_action :authenticate_staff!

  def product_categories_chart
    render json: CalculateMetrics.product_categories
  end

  def time_product_additions_chart
    render json: CalculateMetrics.time_product_additions
  end

  def affiliate_categories_chart
    render json: CalculateMetrics.affiliate_categories
  end

  def time_affiliate_views_chart
    render json: CalculateMetrics.time_affiliate_views
  end

  def visits_by_page_chart
    render json: CalculateMetrics.visits_by_page
  end

  def time_visits_chart
    render json: CalculateMetrics.time_visits
  end

  def vocation_registrations_chart
    render json: CalculateMetrics.vocation_registrations
  end

  def time_registrations_chart
    render json: CalculateMetrics.time_registrations
  end

  def feature_interest_chart
    render json: CalculateMetrics.feature_interest
                                 .group_by { |a| a.first.last }
                                 .map { |feature, data|
                                   { 'name' => feature,
                                     'data' => data.map { |d| [d.first.first, d.last] } }
                                 }
  end
end
