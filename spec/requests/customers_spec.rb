# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'customer', type: :request do
  describe 'GET /customer/show' do
    before { login_as(FactoryBot.create(:customer), scope: :customer) }

    it 'shows the current customer\' dashboard' do
      get '/customer/show'
      expect(response).to be_successful
    end
  end

  describe 'GET /customer/registration' do
    it 'redirects to the sign in page' do
      get '/customer/registration'
      expect(response).to have_http_status 302
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
end
