class MetricsController < ApplicationController

  def index
    @current_nav_identifier = :metrics
    @metrics = Visit.all
    @registrations = Newsletter.all
    metricsCalculator = CalculateMetrics.new(@metrics, @registrations)
    #@features = Features.all

    # Allows the passing of the @metrics, @registrations and @features object to metrics/index.js
    gon.metrics = @metrics
    gon.registrations = @registrations
    gon.pageVisits = metricsCalculator.page_visits
    gon.vocationRegistrations = metricsCalculator.vocation_registrations
    gon.tierRegistrations = metricsCalculator.tier_registrations
    gon.sessionFlows = metricsCalculator.session_flows
  end

  def create
    from = Time.at(params["pageVisitedFrom"].to_i / 1000).to_datetime
    to = Time.at(params["pageVisitedTo"].to_i / 1000).to_datetime

    # Check if user has enabled location services
    if(params.has_key?(:latitude) && params.has_key?(:longitude))
      begin
        results = Geocoder.search([params['latitude'], params['longitude']])
      rescue 
        location = params['location']
      else
        location = results[0].county
      end
    else
      location = params['location']
    end

    # Create instance of visit object
    Visit.create(from: from,
      to: to,
      location: location,
      path: params['path'],
      csrf_token: params['csrf_token'],
      session_identifier: session.id
    )

    head :ok
  end
end