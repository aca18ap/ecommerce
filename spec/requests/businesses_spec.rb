# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Businesses', type: :request do
  describe 'GET /businesses/show' do
    before { login_as(FactoryBot.create(:business)) }

    it 'shows the current business\' dashboard' do
      get '/businesses/show'
      expect(response).to be_successful
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/businesses/destroy'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /businesses/registration' do
    it 'redirects to the sign in page' do
      get '/businesses/registration'
      expect(response).to have_http_status 302
    end
  end

  describe 'POST /businesses' do
    it 'does not allow a new business to be registered' do
      post '/businesses', params: {
        business: {
          email: 'new_business@team04.com',
          password: 'Password123',
          password_confirmation: 'Password123',
          name: 'A Business Name',
          description: 'A business description'
        }
      }

      expect(response).to have_http_status 401
    end
  end

  describe 'PATCH /businesses/:id/unlock' do
    let!(:business) { Business.create(email: 'new_business@team04.com', password: 'Password123', name: 'A Business') }

    before do
      business.lock_access!
      expect(business.access_locked?).to eq true
    end

    context 'If the current user is authenticated as admin' do
      # authenticate_staff! not recognising staff account
      before { login_as(FactoryBot.create(:admin)) }

      it 'unlocks the account specified' do
        patch unlock_business_path(business)
        expect(business.reload.access_locked?).to eq false
      end
    end

    context 'If the current user is not authenticated as admin' do
      it 'does not unlock the account specified' do
        patch unlock_business_path(business)
        expect(business.reload.access_locked?).to eq true
      end
    end
  end
end
