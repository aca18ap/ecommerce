# Retrieves the latitude and longitude values, either
# from the parameter passed to the controller or from the
# client IP address
class RetrieveLocation
  def initialize (params, ip)
    @params = params
    @ip = ip

  end

  def get_location
    if @params.key?(:latitude) && @params.key?(:longitude)
      latitude = @params['latitude']
      longitude = @params['longitude']
    else
      # IP = '90.204.36.252' if localhost to test on dev server
      geocode = Geocoder.search(@ip == '127.0.0.1' ? '90.204.36.252' : @ip).first
      latitude = geocode.latitude
      longitude = geocode.longitude
    end

    return { 'longitude' => longitude, 'latitude' => latitude }
  end
end
