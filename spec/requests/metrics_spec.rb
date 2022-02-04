# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/metrics', type: :request do
  before { login_as(FactoryBot.create(:admin)) }

  describe 'GET /metrics' do
    it 'should show graphs pertaining to registrations, feature views/shares and visits' do
      skip 'WORK OUT HOW BEST TO TEST THIS FEATURE'
    end
  end

  describe 'POST /metrics' do
    it 'should create a new visit from non-staff only pages' do
      expect(Visit.count).to eq(0)

      post '/metrics', params: {
        pageVisitedFrom: '1643892998084',
        pageVisitedTo: '1643893033150',
        path: '/',
        csrf_token: ''
      }

      expect(Visit.count).to eq(1)
    end

    it 'should create a new visit from staff only pages' do
      skip 'FEATURE NEEDS IMPLEMENTING'
      expect(Visit.count).to eq(1)

      post '/metrics', params: {
        pageVisitedFrom: '1643892998084',
        pageVisitedTo: '1643893033150',
        path: '/admin/users',
        csrf_token: ''
      }

      expect(Visit.count).to eq(0)
    end
  end
end
