# frozen_string_literal: true

class MetricsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource class: false, only: [:index]

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
    from = Time.at(params['pageVisitedFrom'].to_i / 1000).to_datetime
    to = Time.at(params['pageVisitedTo'].to_i / 1000).to_datetime

    # Call to service class to find the longitude and latitude for a visit
    location = RetrieveLocation.new(params, request.remote_ip).get_location

    # Create instance of visit object
    Visit.create(from: from,
                 to: to,
                 longitude: location[:longitude],
                 latitude: location[:latitude],
                 path: params['path'],
                 csrf_token: params['csrf_token'],
                 session_identifier: session.id)

    head :ok
  end
end
