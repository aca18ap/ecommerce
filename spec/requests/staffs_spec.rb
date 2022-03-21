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

  describe 'PATCH /staff/:id/unlock' do
    let!(:reporter) { Staff.create(email: 'new_business@team04.com', password: 'Password123', role: Staff.roles[:reporter]) }
    before { login_as(FactoryBot.create(:admin), scope: :staff) }

    before do
      reporter.lock_access!
      expect(reporter.access_locked?).to eq true
    end

    it 'unlocks the account specified' do
      patch unlock_staff_path(reporter)
      expect(reporter.reload.access_locked?).to eq false
    end

  end

  describe 'PATCH /staff/:id/invite' do
    let!(:reporter) { Staff.create(email: 'new_business@team04.com', password: 'Password123', role: Staff.roles[:reporter]) }
    before { login_as(FactoryBot.create(:admin), scope: :staff) }

    it 'resends the invite' do
      expect(reporter.invitation_created_at).to eq nil
      patch invite_staff_path(reporter)

      # Round to nearest minute
      created_at = reporter.reload.invitation_created_at.change({ sec: 0 })
      expect(created_at).to eq Time.now.change({ sec: 0 })
    end
  end

  describe 'PUT /staff/:id' do
    let!(:reporter) { Staff.create(email: 'new_reporter@team04.com', password: 'Password123', role: 'reporter') }

    context 'Security' do
      it 'does not allow the reporter to become an admin via mass assignment' do
        expect(reporter.admin?).to be false
        put staff_path(reporter), params: { staff: { role: 'admin' } }
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

      patch unlock_staff_path(reporter)
      expect(reporter.reload.access_locked?).to eq true

      patch invite_staff_path(reporter)
      expect(reporter.invitation_created_at).to eq nil
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
