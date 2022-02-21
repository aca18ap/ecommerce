# frozen_string_literal: true

require 'rails_helper'
require 'devise'

RSpec.describe '/users', type: :request do
  describe 'PATCH /users/:id/unlock' do
    let!(:user) { User.create(email: 'test@team04.com', password: 'Password123') }

    before do
      user.lock_access!
      expect(user.access_locked?).to eq true
    end

    context 'If the current user is authenticated as admin' do
      before { login_as(FactoryBot.create(:admin)) }

      it 'unlocks the account specified' do
        patch unlock_user_path(user)

        user.reload
        expect(user.access_locked?).to eq false
      end
    end

    context 'If the current user is not authenticated as admin' do
      it 'does not unlock the account specified' do
        patch unlock_user_path(user)

        user.reload
        expect(user.access_locked?).to eq true
      end
    end
  end
end
