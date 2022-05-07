# frozen_string_literal: true

# Handles the creation of new visit objects and the generation of metrics data for display
class MetricsController < ApplicationController
  before_action :authenticate_staff!, only: :index

  def index
    @current_nav_identifier = :metrics
    @visits = Visit.all
    @registrations = Registration.all
    @shares = Share.all
    @products = Product.all
    @affiliate_products = @products.reject { |product| product.business_id.nil? }
    @affiliate_views = AffiliateProductView.all

    gon.visits = @visits
    gon.registrations = @registrations
    gon.sessionFlows = CalculateMetrics.session_flows
  end

  def create
    # Don't track staff only pages or any page when a staff member is logged in
    return if params[:path].match(/admin|reporter|staff/) || current_staff

    # Call to service class to find the longitude and latitude for a visit
    location = RetrieveLocation.new(params, request.remote_ip).location

    # Create instance of visit object
    Visit.create(from: Time.at(params[:pageVisitedFrom].to_i / 1000).to_datetime,
                 to: Time.at(params[:pageVisitedTo].to_i / 1000).to_datetime,
                 longitude: location[:longitude],
                 latitude: location[:latitude],
                 path: params[:path],
                 csrf_token: params[:csrf_token],
                 session_identifier: session.id)

    head :ok
  end
end
