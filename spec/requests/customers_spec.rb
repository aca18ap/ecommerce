# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'customer', type: :request do
  describe 'GET /customer/show' do
    before { login_as(FactoryBot.create(:customer), scope: :customer) }

    it 'shows the current customer\' dashboard' do
      get customer_show_path
      expect(response).to be_successful
    end
  end

  describe 'PATCH /customer/:id/unlock' do
    let!(:customer) { Customer.create(email: 'new_customer@team04.com', password: 'Password123', username: 'A customer') }

    before do
      customer.lock_access!
      expect(customer.access_locked?).to eq true
    end

    context 'If the current user is authenticated as admin' do
      before { login_as(FactoryBot.create(:admin), scope: :staff) }

      it 'unlocks the account specified' do
        patch unlock_customer_path(customer)
        expect(customer.reload.access_locked?).to eq false
      end
    end

    context 'If the current user is not authenticated as admin' do
      it 'does not unlock the account specified' do
        patch unlock_customer_path(customer)
        expect(customer.reload.access_locked?).to eq true
      end
    end
  end

  describe 'If I am not logged in as a customer' do
    let(:customer) { FactoryBot.create(:customer) }

    def check_routes
      get customer_show_path
      assert_response 302

      get customer_path(customer)
      assert_response 302
    end

    it 'does not let me access the routes if I am not logged in' do
      check_routes
    end

    it 'does not let me access the routes if I am logged in as a staff member' do
      login_as(FactoryBot.create(:admin), scope: :staff)
      check_routes
      post customer_registration_path
      assert_response 302
    end

    it 'does not let me access the routes if I am logged in as a business' do
      login_as(FactoryBot.create(:business), scope: :business)
      check_routes
      post customer_registration_path
      assert_response 302
    end
  end
end
