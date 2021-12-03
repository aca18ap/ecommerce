class MetricsController < ApplicationController

  def index
    @current_nav_identifier = :metrics
    @metrics = Visit.all

    # Allows the passing of the @metrics object to metric.js
    gon.metrics = @metrics
  end

  def create
    from = Time.at(params["pageVisitedFrom"].to_i / 1000).to_datetime
    to = Time.at(params["pageVisitedTo"].to_i / 1000).to_datetime

    Visit.create(from: from,
      to: to,
      location: params['location'],
      path: params['path'],
      csrf_token: params['authenticity_token'],
      session_identifier: session.id
    )

    head :ok
  end
end