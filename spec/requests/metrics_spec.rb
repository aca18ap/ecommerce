# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/metrics', type: :request do
  before { login_as(FactoryBot.create(:admin)) }

  describe 'POST /metrics' do
    context 'From non-staff-only pages' do
      it 'should create a new visit' do
        expect(Visit.count).to eq 0

        post '/metrics', params: {
          pageVisitedFrom: '1643892998084',
          pageVisitedTo: '1643893033150',
          path: '/',
          csrf_token: ''
        }

        expect(Visit.count).to eq 1
        expect(Visit.last.path).to eq '/'
      end
    end

    context 'From staff-only pages' do
      it 'should not create a new visit' do
        skip 'FEATURE NEEDS IMPLEMENTING'
        expect(Visit.count).to eq 1

        post '/metrics', params: {
          pageVisitedFrom: '1643892998084',
          pageVisitedTo: '1643893033150',
          path: '/admin/users',
          csrf_token: ''
        }

        expect(Visit.count).to eq 0
        expect(Visit.last.path).to eq '/admin/users'
      end
    end
  end
end
