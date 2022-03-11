# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/staffs', type: :request do
  describe 'If I am logged in as an admin' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    let!(:reporter) { FactoryBot.create(:reporter) }

    describe 'GET /admin/staff/:id/edit' do
      it 'retrieves the edit form a staff member' do
        get edit_admin_staff_path(reporter)
        expect(response.body).to include reporter.email
      end
    end

    describe 'PATCH /admin/staff/:id' do
      it 'updates the data for a staff member' do
        patch admin_staff_path(reporter), params: { staff: { email: 'new_email@team04.com' } }

        expect(reporter.reload.email).to eq 'new_email@team04.com'
      end
    end

    describe 'PUT /admin/staff/:id' do
      it 'updates the data for a staff member' do
        put admin_staff_path(reporter), params: { staff: { email: 'new_email@team04.com' } }

        expect(reporter.reload.email).to eq 'new_email@team04.com'
      end
    end

    describe 'DELETE /admin/staff/:id' do
      it 'deletes the staff member' do
        delete admin_staff_path(reporter)
        expect(Staff.find_by_id(reporter)).to eq nil
      end
    end
  end

  describe 'If I am not logged in as an admin' do
    let(:reporter) { FactoryBot.create(:reporter) }

    def check_routes
      get edit_admin_staff_path(reporter)
      assert_response 302

      patch admin_staff_path(reporter)
      assert_response 302

      put admin_staff_path(reporter)
      assert_response 302

      delete admin_staff_path(reporter)
      assert_response 302
    end

    it 'does not let me access the routes if I am not logged in' do
      check_routes
    end

    it 'does not let me access the routes if I am logged in as a reporter' do
      login_as(FactoryBot.create(:reporter, email: 'reporter2@team04.com'), scope: :staff)
      check_routes
    end

    it 'does not let me access the routes if I am logged in as a business' do
      login_as(FactoryBot.create(:business), scope: :business)
      check_routes
    end

    it 'does not let me access the routes if I am logged in as a customer' do
      login_as(FactoryBot.create(:customer), scope: :customer)
      check_routes
    end
  end
end
