class MetricsController < ApplicationController

  def index
    @current_nav_identifier = :metrics
    @metrics = Visit.all
    @registrations = Newsletter.all
    #@features = Features.all

    # Allows the passing of the @metrics, @registrations and @features object to metrics/index.js
    gon.metrics = @metrics
    gon.registrations = @registrations
    #gon.features = @features
  end

  def create
    from = Time.at(params["pageVisitedFrom"].to_i / 1000).to_datetime
    to = Time.at(params["pageVisitedTo"].to_i / 1000).to_datetime

    Visit.create(from: from,
      to: to,
      # location: params['location'],
      latitude: params['latitude'],
      longitude: params['longitude'],
      path: params['path'],
      csrf_token: params['authenticity_token'],
      session_identifier: session.id
    )

    head :ok
  end
end