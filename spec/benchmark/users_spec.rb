# frozen_string_literal: true

require 'rails_helper'

describe 'Admin Users Page' do
  context 'Given there are 10,000 Customers in the system' do
    before do
      current_time = Time.zone.now
      Customer.insert_all(
        10_000.times.map do |i|
          {
            email: "customer#{i}@team04.com",
            # password: "Password123",
            username: "MyUsername#{i}",
            created_at: current_time,
            updated_at: current_time
          }
        end
      )
    end

    context 'As an admin' do
      specify 'I can see the list of Customers within 0.5 second of visiting the page' do
        login_as(FactoryBot.create(:admin), scope: :staff)
        expect do
          visit admin_users_path
        end.to perform_under(0.5).sec
      end
    end
  end
end
