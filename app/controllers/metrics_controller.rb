# frozen_string_literal: true

# Handles the creation of new visit objects and the generation of metrics data for display
class MetricsController < ApplicationController
  before_action :authenticate_staff!, only: :index

  def index
    @current_nav_identifier = :metrics
    @visits = Visit.all
    @registrations = Newsletter.all
    @shares = Share.all

    gon.visits = @visits
    gon.registrations = @registrations
    gon.shares = @shares
    gon.pageVisits = CalculateMetrics.page_visits(@visits)
    gon.timeVisits = CalculateMetrics.time_visits(@visits)
    gon.vocationRegistrations = CalculateMetrics.vocation_registrations(@registrations)
    gon.tierRegistrations = CalculateMetrics.tier_registrations(@registrations)
    gon.sessionFlows = CalculateMetrics.session_flows(@visits)
    gon.timeVisits = CalculateMetrics.time_visits(@visits)
    gon.timeRegistrations = CalculateMetrics.time_registrations(@registrations)
    gon.featureShares = CalculateMetrics.feature_shares(@shares)
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
end
