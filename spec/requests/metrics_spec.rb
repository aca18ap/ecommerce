# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/metrics', type: :request do
  before { login_as(FactoryBot.create(:admin)) }

  def post_to_metrics(path)
    post '/metrics', params: {
      pageVisitedFrom: '1643892998084',
      pageVisitedTo: '1643893033150',
      path: path,
      csrf_token: ''
    }
  end

  describe 'POST /metrics' do
    context 'From non-staff-only pages' do
      it 'should create a new visit' do
        expect(Visit.count).to eq 0
        post_to_metrics('/')

        expect(Visit.count).to eq 1
        expect(Visit.last.path).to eq '/'
      end
    end

    context 'Should not create a new visit' do
      it 'from admin-only pages' do
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
