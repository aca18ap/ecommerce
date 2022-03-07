# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/users', type: :request do
  before { login_as(FactoryBot.create(:admin), scope: :staff) }

  describe 'GET /admin/users' do
    it 'Shows a list of all users in the system' do
      5.times do |idx|
        Customer.create(email: "user#{idx}@team04.com",
                        username: "user#{idx}",
                        password: 'Password123',
                        password_confirmation: 'Password123')

        Staff.create(email: "staff#{idx}@team04.com",
                     password: 'Password123',
                     password_confirmation: 'Password123')

        Business.create(email: "business#{idx}@team04.com",
                        name: "business#{idx}",
                        password: 'Password123',
                        password_confirmation: 'Password123')
      end

      get admin_users_path
      expect(response).to be_successful

      5.times do |idx|
        expect(response.body).to include "user#{idx}@team04.com"
        expect(response.body).to include "staff#{idx}@team04.com"
        expect(response.body).to include "business#{idx}@team04.com"
      end
    end
  end
end
