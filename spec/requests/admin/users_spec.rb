# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/users', type: :request do
  before { login_as(FactoryBot.create(:admin)) }

  describe 'GET /admin/users' do
    it 'Shows a list of all users in the system, their roles and some actions to perform' do
      10.times do |idx|
        User.create(email: "user#{idx}@team04.com",
                    password: 'Password123',
                    password_confirmation: 'Password123',
                    role: 'customer')
      end

      get admin_users_path
      expect(response).to be_successful

      10.times do |idx|
        expect(response.body).to include "user#{idx}@team04.com"
      end
    end
  end

  describe 'POST /admin/users' do
    it 'Creates a new user' do
      skip 'DON\'T THINK THIS ROUTE IS USED. CHECK BEFORE DELETING'
    end
  end
end
