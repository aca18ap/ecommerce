# frozen_string_literal: true

require 'rails_helper'

Geocoder.configure(ip_lookup: :test)

Geocoder::Lookup::Test.add_stub(
  '1.1.1.1', [
    {
      :latitude => -1.488707,
      :longitude => 53.3705604,
      'address' => 'Test Address',
      'state' => 'Test State',
      'state_code' => 'TS',
      'country' => 'Test Country',
      'country_code' => 'TC'
    }
  ]
)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      :latitude => -1.488707,
      :longitude => 53.3705604,
      'address' => 'Test Address',
      'state' => 'Test State',
      'state_code' => 'TS',
      'country' => 'Test Country',
      'country_code' => 'TC'
    }
  ]
)

describe 'Retrieve location', js: true do
  let(:all_data) { RetrieveLocation.new({ longitude: 53.958332, latitude: -1.080278 }, '') }
  let(:no_location) { RetrieveLocation.new({}, '1.1.1.1') }
  let(:localhost) { RetrieveLocation.new({}, '127.0.0.1') }
  let(:none) { RetrieveLocation.new({}, nil) }

  it 'Returns the latitude and longitude parameters if they are present' do
    location = all_data.location
    expect(location[:latitude]).to eq(-1.080278)
    expect(location[:longitude]).to eq(53.958332)
  end

  it 'Retrieves the latitude and longitude from the IP address if they aren\'t present in the parameters' do
    location = no_location.location
    expect(location[:latitude]).to eq(-1.488707)
    expect(location[:longitude]).to eq(53.3705604)
  end

  it 'Retrieves the latitude and longitude from a hard coded IP if localhost is being used' do
    # 1.1.1.1 set as default
    location = localhost.location
    expect(location[:latitude]).to eq(-1.488707)
    expect(location[:longitude]).to eq(53.3705604)
  end

  it 'Returns nil if no params or IP are present' do
    skip 'skipping to fix demo site'
    location = none.location
    expect(location[:latitude]).to eq(nil)
    expect(location[:longitude]).to eq(nil)
  end
end
