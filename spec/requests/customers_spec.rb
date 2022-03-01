# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Customers", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/customers/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/customers/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/customers/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/customers/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/customers/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/customers/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /businesses/:id/unlock' do
    let!(:customer) { Customer.create(email: 'new_customer@team04.com', password: 'Password123', username: 'Username') }

    before do
      customer.lock_access!
      expect(customer.access_locked?).to eq true
    end

    context 'If the current user is authenticated as admin' do
      before { login_as(FactoryBot.create(:admin)) }

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
