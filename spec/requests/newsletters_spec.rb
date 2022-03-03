# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/newsletters', type: :request do
  describe 'GET /newsletters' do
    before { login_as(FactoryBot.create(:admin)) }

    it 'Shows a list of all newsletters' do
      10.times do |idx|
        Newsletter.create(email: "customer#{idx}@team04.com", vocation: 'Customer')
      end

      get newsletters_path
      expect(response).to be_successful

      10.times do |idx|
        expect(response.body).to include "customer#{idx}@team04.com"
      end
    end
  end

  describe 'POST /newsletters' do
    it 'Creates a new newsletter' do
      expect(Newsletter.count).to eq 0

      post newsletters_path, params: {
        newsletter: {
          email: 'customer@team04.com',
          vocation: 'Customer'
        }
      }

      expect(Newsletter.count).to eq 1
    end
  end
end
