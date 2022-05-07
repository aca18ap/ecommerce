# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/metrics', type: :request do
  def post_to_metrics(path)
    post '/metrics', params: {
      pageVisitedFrom: '1643892998084',
      pageVisitedTo: '1643893033150',
      path: path,
      csrf_token: ''
    }
  end

  describe 'GET /metrics' do
    context 'If logged in as a staff member' do
      it 'allows the page to be accessed if logged in as an admin' do
        login_as(FactoryBot.create(:admin), scope: :staff)
        get metrics_path
        expect(response).to be_successful
      end

      it 'allows the page to be accessed if logged in as an admin' do
        login_as(FactoryBot.create(:reporter), scope: :staff)
        get metrics_path
        expect(response).to be_successful
      end
    end

    context 'If not logged in as a staff member' do
      it 'Does not allow the page to be accessed by logged out users' do
        get metrics_path
        expect(response).to_not be_successful
      end

      it 'Does not allow the page to be accessed by customers' do
        login_as(FactoryBot.create(:customer), scope: :customer)
        get metrics_path
        expect(response).to_not be_successful
      end

      it 'Does not allow the page to be accessed by businesses' do
        login_as(FactoryBot.create(:business), scope: :business)
        get metrics_path
        expect(response).to_not be_successful
      end
    end
  end

  describe 'POST /metrics' do
    context 'when accessing non-staff-only pages' do
      it 'creates a new visit' do
        expect(Visit.count).to eq 0
        post_to_metrics('/')

        expect(Visit.count).to eq 1
        expect(Visit.last.path).to eq '/'
      end
    end

    context 'when accessing staff only pages' do
      it 'does not create a new visit' do
        expect(Visit.count).to eq 0
        post_to_metrics('/admin/users')

        expect(Visit.count).to eq 0
      end

      it 'from reporter-only pages' do
        expect(Visit.count).to eq 0
        post_to_metrics('/reporter/users')

        expect(Visit.count).to eq 0
      end

      it 'from staff-only pages' do
        expect(Visit.count).to eq 0
        post_to_metrics('/staff/users')

        expect(Visit.count).to eq 0
      end
    end
  end
end
