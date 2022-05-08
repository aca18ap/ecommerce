# frozen_string_literal: true

# Handles the end points for business graphs to improve page load times on business dashboard
class BusinessGraphsController < ApplicationController
  before_action :authenticate_business!

  def time_product_views_chart
    render json: BusinessMetrics.time_affiliate_views(current_business)
  end

  def views_by_product_chart
    render json: BusinessMetrics.views_by_product(current_business)
  end

  def views_by_category_chart
    render json: BusinessMetrics.views_by_category(current_business)
  end
end
