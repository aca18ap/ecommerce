# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'staff', type: :request do
  describe 'GET /staff/show' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }

    it 'shows the current staff\' dashboard' do
      get '/staff/show'
      expect(response).to be_successful
    end
  end

  describe 'GET /staff/registration' do
    it 'redirects to the sign in page' do
      get '/staff/registration'
      expect(response).to have_http_status 302
    end
  end

  describe 'POST /staff' do
    it 'does not allow a new staff to be registered' do
      post '/staff', params: {
        staff: {
          email: 'new_staff@team04.com',
          password: 'Password123',
          password_confirmation: 'Password123',
        }
      }

      expect(response).to have_http_status 401
    end
  end

  describe 'PUT /staff/:id' do
    let!(:reporter) { Staff.create(email: 'new_reporter@team04.com', password: 'Password123', role: 'reporter') }

    context 'Security' do
      it 'does not allow the reporter to become an admin via mass assignment' do
        expect(reporter.admin?).to be false
        put staff_path(reporter), params: {
          staff: {
            role: 'admin'
          }
        }
        expect(response).to_not be_successful
        expect(reporter.reload.admin?).to be false
      end
    end
  end
end
