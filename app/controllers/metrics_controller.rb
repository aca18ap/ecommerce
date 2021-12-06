class MetricsController < ApplicationController

  def index
    @current_nav_identifier = :metrics
    @metrics = Visit.all
    @registrations = Newsletter.all

    # Allows the passing of the @metrics and @registrations object to metrics/index.js
    gon.metrics = @metrics
    gon.registrations = @registrations
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