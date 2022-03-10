# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/reviews', type: :request do
  describe 'GET /reviews' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }

    describe 'If the user is logged in as an admin' do
      it 'Shows a list of all the reviews in the system' do
        10.times do |idx|
          Review.create(description: "Review #{idx}")
        end

        get reviews_path
        expect(response).to be_successful

        10.times do |idx|
          expect(response.body).to include "Review #{idx}"
        end
      end
    end
  end

  describe 'If the user is not logged in as an admin' do
    it 'Should be redirected' do
      get reviews_path

      expect(response.status).to eq 302
    end
  end

  describe 'POST /reviews' do
    it 'creates a new review' do
      expect(Review.count).to eq 0

      post reviews_path, params: { review: { description: 'A new review' } }

      expect(Review.count).to eq 1
    end
  end
end
