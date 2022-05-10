# frozen_string_literal: true

# Handles the end points for customer graphs to improve page load times on customer dashboard
class CustomerGraphsController < ApplicationController
  before_action :authenticate_customer!

  def time_co2_per_purchase_chart
    sum = 0
    render json: CustomerMetrics.time_co2_per_purchase(current_customer).map { |date, value| [date, sum += value.to_f] }
  end

  def time_total_co2_chart
    sum = 0
    render json: CustomerMetrics.time_total_co2(current_customer).map { |date, value| [date, sum += value] }
  end

  def time_co2_saved_chart
    sum = 0
    render json: CustomerMetrics.time_co2_saved(current_customer).map { |date, value| [date, sum += value] }
  end

  def time_co2_per_pound_chart
    sum = 0
    render json: CustomerMetrics.time_co2_per_pound(current_customer).map { |date, value| [date, sum += value] }
  end

  def time_products_added_chart
    sum = 0
    render json: CustomerMetrics.time_products_added(current_customer).map { |date, value| [date, sum += value] }
  end
end
