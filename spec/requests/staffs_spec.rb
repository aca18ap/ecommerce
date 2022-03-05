# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'staff', type: :request do
  describe 'GET /staff/show' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }

    it 'shows the current staff\' dashboard' do
      get staff_show_path
      expect(response).to be_successful
    end
  end

  describe 'GET /staff/registration' do
    it 'redirects to the sign in page' do
      get new_staff_registration_path
      expect(response).to have_http_status 302
    end
  end

  describe 'POST /staff' do
    it 'does not allow a new staff to be registered' do
      post staff_registration_path, params: {
        staff: {
          email: 'new_staff@team04.com',
          password: 'Password123',
          password_confirmation: 'Password123'
        }
      }

      assert_response :forbidden
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

  describe 'If I am not logged in as a staff member' do
    let(:reporter) { FactoryBot.create(:reporter) }

    def check_routes
      get staff_show_path
      assert_response 302

      get new_staff_registration_path
      assert_response 302

      put staff_path(reporter)
      assert_response 302
    end

    it 'does not let me access the routes if I am not logged in' do
      check_routes
      post staff_registration_path
      assert_response 403
    end

    it 'does not let me access the routes if I am logged in as a business' do
      login_as(FactoryBot.create(:business), scope: :business)
      check_routes
      post staff_registration_path
      assert_response 302
    end

    it 'does not let me access the routes if I am logged in as a customer' do
      login_as(FactoryBot.create(:customer), scope: :customer)
      check_routes
      post staff_registration_path
      assert_response 302
    end
  end
end
