# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BusinessGraphs', type: :request do
  describe 'As a business' do
    before { login_as(FactoryBot.create(:business), scope: :business) }

    it 'successfully returns a json containing my graph data' do
      get time_product_views_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get views_by_product_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'

      get views_by_category_chart_path
      expect(response).to be_successful
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end

  describe 'As any other user type other than a business' do
    def check_routes
      get time_product_views_chart_path
      expect(response).to_not be_successful

      get views_by_product_chart_path
      expect(response).to_not be_successful

      get views_by_category_chart_path
      expect(response).to_not be_successful
    end

    it 'does not let me access business graphs if I am not logged in' do
      check_routes
    end

    it 'does not let me access business graphs as a customer' do
      login_as(FactoryBot.create(:customer), scope: :customer)
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
