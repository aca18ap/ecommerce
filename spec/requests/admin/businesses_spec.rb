# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/business', type: :request do
  describe 'If I am logged in as an admin' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    let!(:business) { FactoryBot.create(:business) }

    describe 'GET /admin/business/:id/edit' do
      it 'retrieves the edit form a business' do
        get edit_admin_business_path(business)
        expect(response.body).to include business.email
      end
    end

    describe 'PATCH /admin/business/:id' do
      it 'updates the data for a business' do
        patch admin_business_path(business), params: {
          business: {
            email: 'new_email@team04.com'
          }
        }

        expect(business.reload.email).to eq 'new_email@team04.com'
      end
    end

    describe 'PUT /admin/business/:id' do
      it 'updates the data for a business' do
        put admin_business_path(business), params: {
          business: {
            email: 'new_email@team04.com'
          }
        }

        expect(business.reload.email).to eq 'new_email@team04.com'
      end
    end

    describe 'DELETE /admin/business/:id' do
      it 'deletes the business' do
        delete admin_business_path(business)
        expect(Business.find_by_id(business)).to eq nil
      end
    end
  end

  describe 'If I am not logged in as an admin' do
    let(:business) { FactoryBot.create(:business) }

    def check_routes
      get edit_admin_business_path(business)
      assert_response 302

      patch admin_business_path(business)
      assert_response 302

      put admin_business_path(business)
      assert_response 302

      delete admin_business_path(business)
      assert_response 302
    end

    it 'does not let me access the routes if I am not logged in' do
      check_routes
    end

    it 'does not let me access the routes if I am logged in as a reporter' do
      login_as(FactoryBot.create(:reporter), scope: :staff)
      check_routes
    end

    it 'does not let me access the routes if I am logged in as a business' do
      login_as(FactoryBot.create(:business, email: 'business2@team04.com'), scope: :business)
      check_routes
    end

    it 'does not let me access the routes if I am logged in as a customer' do
      login_as(FactoryBot.create(:customer), scope: :customer)
      check_routes
    end
  end
end
