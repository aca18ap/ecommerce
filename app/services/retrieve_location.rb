# frozen_string_literal: true

# Retrieves the latitude and longitude values, either
# from the parameter passed to the controller or from the
# client IP address
class RetrieveLocation
  def initialize(params, ip)
    @params = params
    @ip = ip
  end

  # Gets location. Defaults to params and uses IP if the params do not contain
  # latitude and longitude values
  def get_location
    if !@params.nil? && @params.include?(:latitude) && @params.include?(:longitude)
      latitude = @params[:latitude]
      longitude = @params[:longitude]
    else
      # IP = '90.204.36.252' if localhost to test on dev server
      geocode = Geocoder.search(@ip == '127.0.0.1' ? '94.3.89.188' : @ip).first

      begin
        latitude = geocode.latitude
        longitude = geocode.longitude
      rescue StandardError
        longitude = nil
        latitude = nil
      end
    end

    { longitude: longitude, latitude: latitude }
  end
end
