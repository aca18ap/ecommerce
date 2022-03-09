# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/customer', type: :request do
  describe 'If I am logged in as an admin' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    let!(:customer) { FactoryBot.create(:customer) }

    describe 'GET /admin/customer/:id/edit' do
      it 'retrieves the edit form a customer' do
        get edit_admin_customer_path(customer)
        expect(response.body).to include customer.email
      end
    end

    describe 'PATCH /admin/customer/:id' do
      it 'updates the data for a customer' do
        patch admin_customer_path(customer), params: {
          customer: {
            email: 'new_email@team04.com'
          }
        }

        expect(customer.reload.email).to eq 'new_email@team04.com'
      end
    end

    describe 'PUT /admin/customer/:id' do
      it 'updates the data for a customer' do
        put admin_customer_path(customer), params: {
          customer: {
            email: 'new_email@team04.com'
          }
        }

        expect(customer.reload.email).to eq 'new_email@team04.com'
      end
    end

    describe 'DELETE /admin/customer/:id' do
      it 'deletes the customer' do
        delete admin_customer_path(customer)
        expect(Customer.find_by_id(customer)).to eq nil
      end
    end
  end

  describe 'If I am not logged in as an admin' do
    let(:customer) { FactoryBot.create(:customer) }

    def check_routes
      get edit_admin_customer_path(customer)
      assert_response 302

      patch admin_customer_path(customer)
      assert_response 302

      put admin_customer_path(customer)
      assert_response 302

      delete admin_customer_path(customer)
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
      login_as(FactoryBot.create(:business), scope: :business)
      check_routes
    end

    it 'does not let me access the routes if I am logged in as a customer' do
      login_as(FactoryBot.create(:customer, email: 'customer2@team04.com', username: 'User2'), scope: :customer)
      check_routes
    end
  end
end
