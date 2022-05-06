# frozen_string_literal: true

# Handles the end points for customer graphs to improve page load times on customer dashboard
class CustomerGraphsController < ApplicationController
  def time_co2_per_purchase_chart
    render json: CustomerMetrics.time_co2_per_purchase(current_customer)
  end

  def time_total_co2_chart
    render json: CustomerMetrics.time_total_co2(current_customer)
  end

  def time_co2_saved_chart
    render json: CustomerMetrics.time_co2_saved(current_customer)
  end

  def time_co2_per_pound_chart
    render json: CustomerMetrics.time_co2_per_pound(current_customer)
  end

  def time_products_added_chart
    render json: CustomerMetrics.time_products_added(current_customer)
  end
end
