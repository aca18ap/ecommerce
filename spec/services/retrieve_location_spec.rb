require 'rails_helper'


describe 'Retrieve location', js: true do

  let(:all_data) { RetrieveLocation.new({ 'longitude' => 53.958332, 'latitude' => -1.080278 }, '') }
  # Google IP chosen as it is very unlikely to ever change
  let(:no_location) { RetrieveLocation.new({}, '8.8.8.8') }
  let(:localhost) { RetrieveLocation.new({}, '127.0.0.1') }
  let(:none) { RetrieveLocation.new({}, nil) }

  it 'Returns the latitude and longitude parameters if they are present' do
    location = all_data.get_location
    expect(location['latitude']).to eq(-1.080278)
    expect(location['longitude']).to eq(53.958332)
  end

  it 'Retrieves the latitude and longitude from the IP address if they aren\'t present in the parameters' do
    location = no_location.get_location
    expect(location['latitude']).to eq(37.405992)
    expect(location['longitude']).to eq(-122.078515)
  end

  it 'Retrieves the latitude and longitude from a hard coded IP if localhost is being used' do
    # 90.204.36.252
    location = localhost.get_location
    expect(location['latitude']).to eq(-1.488707)
    expect(location['longitude']).to eq(53.3705604)
  end

  it 'Returns nil if no params or IP are present' do
    location = none.get_location
    expect(location['latitude']).to eq(nil)
    expect(location['longitude']).to eq(nil)
  end
end
