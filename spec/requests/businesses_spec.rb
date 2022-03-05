# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Business', type: :request do
  describe 'GET /business/show' do
    before { login_as(FactoryBot.create(:business), scope: :business) }

    it 'shows the current business\' dashboard' do
      get '/business/show'
      expect(response).to be_successful
    end
  end

  describe 'GET /business/registration' do
    it 'redirects to the sign in page' do
      get '/business/registration'
      expect(response).to have_http_status 302
    end
  end

  describe 'POST /business' do
    it 'does not allow a new business to be registered' do
      post '/business', params: {
        business: {
          email: 'new_business@team04.com',
          password: 'Password123',
          password_confirmation: 'Password123',
          name: 'A Business Name',
          description: 'A business description'
        }
      }

      assert_response :forbidden
    end
  end

  describe 'PATCH /business/:id/unlock' do
    let!(:business) { Business.create(email: 'new_business@team04.com', password: 'Password123', name: 'A Business') }

    before do
      business.lock_access!
      expect(business.access_locked?).to eq true
    end

    context 'If the current user is authenticated as admin' do
      # authenticate_staff! not recognising staff account
      before { login_as(FactoryBot.create(:admin), scope: :staff) }

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
