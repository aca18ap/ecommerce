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

    # Sends the gon gem variables to the js front end
    send_gon_variables
  end

  def create
    # Don't track staff only pages
    return if params[:path].match(/admin|reporter|staff/)

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

  private

  def send_gon_variables
    # Visits
    gon.visits = @visits
    gon.pageVisits = CalculateMetrics.page_visits(@visits)
    gon.timeVisits = CalculateMetrics.time_visits(@visits)
    gon.sessionFlows = CalculateMetrics.session_flows(@visits)
    gon.timeVisits = CalculateMetrics.time_visits(@visits)

    # Registrations
    gon.registrations = @registrations
    gon.vocationRegistrations = CalculateMetrics.vocation_registrations(@registrations)
    gon.timeRegistrations = CalculateMetrics.time_registrations(@registrations)

    # Shares
    gon.shares = @shares
    gon.featureShares = CalculateMetrics.feature_shares(@shares)

    # Products
    gon.products = @products
    gon.timeProducts = CalculateMetrics.time_products(@products)
    gon.productCategories = CalculateMetrics.product_categories
    gon.affiliateProductCategories = CalculateMetrics.affiliate_product_categories
    gon.timeAffiliateViews = CalculateMetrics.time_affiliate_views
  end
end
