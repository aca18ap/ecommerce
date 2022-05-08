# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'MetricsGraphs', type: :request do
  describe 'As a staff member' do
    def check_routes
      get product_categories_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get time_product_additions_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get affiliate_categories_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get time_affiliate_views_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get visits_by_page_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get time_visits_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get vocation_registrations_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get time_registrations_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get feature_interest_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it 'successfully returns a json containing graph data if I am logged in as an admin' do
      login_as(FactoryBot.create(:reporter), scope: :staff)
      check_routes
    end
  end

  describe 'As any other user type other than a staff member' do
    def check_routes
      get product_categories_chart_path
      expect(response).to_not be_successful

      get time_product_additions_chart_path
      expect(response).to_not be_successful

      get affiliate_categories_chart_path
      expect(response).to_not be_successful

      get time_affiliate_views_chart_path
      expect(response).to_not be_successful

      get visits_by_page_chart_path
      expect(response).to_not be_successful

      get time_visits_chart_path
      expect(response).to_not be_successful

      get vocation_registrations_chart_path
      expect(response).to_not be_successful

      get time_registrations_chart_path
      expect(response).to_not be_successful

      get feature_interest_chart_path
      expect(response).to_not be_successful
    end

    it 'does not let me access business graphs if I am not logged in' do
      check_routes
    end

    it 'does not let me access business graphs as a business' do
      login_as(FactoryBot.create(:business), scope: :business)
      check_routes
    end

    it 'does not let me access business graphs as a customer' do
      login_as(FactoryBot.create(:customer), scope: :customer)
      check_routes
    end
  end
end
