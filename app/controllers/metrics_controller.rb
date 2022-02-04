class MetricsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource :class => false, :only => [:index]

  def index
    @current_nav_identifier = :metrics
    @visits = Visit.all
    @registrations = Newsletter.all
    @shares = Share.all

    # Passes metrics calculated in service class to metrics/index.js using gon gem
    metrics_calculator = CalculateMetrics.new(@visits, @registrations, @shares)
    gon.visits = @visits
    gon.registrations = @registrations
    gon.shares = @shares
    gon.pageVisits = metrics_calculator.page_visits
    gon.timeVisits = metrics_calculator.time_visits
    gon.vocationRegistrations = metrics_calculator.vocation_registrations
    gon.tierRegistrations = metrics_calculator.tier_registrations
    gon.sessionFlows = metrics_calculator.session_flows
    gon.timeVisits = metrics_calculator.time_visits
    gon.timeRegistrations = metrics_calculator.time_registrations
  end

  def create
    from = Time.at(params['pageVisitedFrom'].to_i / 1000).to_datetime
    to = Time.at(params['pageVisitedTo'].to_i / 1000).to_datetime

    # Call to service class to find the longitude and latitude for a visit
    location = RetrieveLocation.new(params, request.remote_ip).get_location

    # Create instance of visit object
    Visit.create(from: from,
                 to: to,
                 longitude: location['longitude'],
                 latitude: location['latitude'],
                 path: params['path'],
                 csrf_token: params['csrf_token'],
                 session_identifier: session.id)

    head :ok
  end
end
