# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CustomerGraphs', type: :request do
  describe 'As a customer' do
    before { login_as(FactoryBot.create(:customer), scope: :customer) }

    it 'successfully returns a json containing my graph data' do
      get time_co2_per_purchase_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get time_total_co2_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get time_co2_saved_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get time_co2_per_pound_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get time_products_added_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end

  describe 'As any other user type other than a business' do
    def check_routes
      get time_co2_per_purchase_chart_path
      expect(response).to_not be_successful

      get time_total_co2_chart_path
      expect(response).to_not be_successful

      get time_co2_saved_chart_path
      expect(response).to_not be_successful

      get time_co2_per_pound_chart_path
      expect(response).to_not be_successful

      get time_products_added_chart_path
      expect(response).to_not be_successful
    end

    it 'does not let me access business graphs if I am not logged in' do
      check_routes
    end

    it 'does not let me access business graphs as a business' do
      login_as(FactoryBot.create(:business), scope: :business)
      check_routes
    end

    it 'does not let me access business graphs as a reporter' do
      login_as(FactoryBot.create(:reporter), scope: :staff)
      check_routes
    end

    it 'does not let me access business graphs as an admin' do
      login_as(FactoryBot.create(:admin), scope: :staff)
      check_routes
    end
  end
end
