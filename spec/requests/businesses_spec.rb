# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Business', type: :request do
  describe 'GET /business/:id/' do
    let(:business) { FactoryBot.create(:business) }
    it 'If I visit the profile URL I see the profile' do
      get business_path(business)
      expect(response).to be_successful
    end
  end

  describe 'GET /business/show as roles' do
    let(:business) { FactoryBot.create(:business) }

    def check_routes
      get new_business_registration_path
      assert_response 302

      get business_path(business)
      assert_response 200
    end

    it 'I can view a business\' profile' do
      get business_path(business)
      expect(response).to be_successful
    end

    it 'does not let me access the routes if I am logged in as a staff member' do
      login_as(FactoryBot.create(:admin), scope: :staff)
      check_routes
      post business_registration_path
      assert_response 302
    end

    it 'does not let me access the routes if I am logged in as a customer' do
      login_as(FactoryBot.create(:customer), scope: :customer)
      check_routes
      post business_registration_path
      assert_response 302
    end
  end

  describe 'GET /business/registration' do
    it 'redirects to the sign in page' do
      get new_business_registration_path
      assert_response 302
    end
  end

  describe 'POST /business' do
    it 'does not allow a new business to be registered' do
      post business_registration_path, params: {
        business: {
          email: 'new_business@team04.com',
          password: 'Password123',
          password_confirmation: 'Password123',
          name: 'A Business Name',
          description: 'A business description'
        }
      }

      assert_response :forbidden
    end
  end

  describe 'PUT /business/invitation' do
    let!(:business) { Business.create(email: 'new_business@team04.com', name: 'A Business') }

    before do
      business.invite!
      expect(Registration.count).to be 0

      @raw_token = business.instance_variable_get(:@raw_invitation_token)
    end

    it 'creates a registration entry if the invitation was successfully accepted' do
      put business_invitation_path, params: {
        business: {
          invitation_token: @raw_token,
          password: 'Password123',
          password_confirmation: 'Password123'
        }
      }

      expect(Registration.count).to be 1
    end

    it 'does not create a registration entry if the invitation unsuccessful' do
      put business_invitation_path, params: {
        business: {
          invitation_token: @raw_token,
          password: 'invalid',
          password_confirmation: 'invalid'
        }
      }

      expect(Registration.count).to be 0
    end
  end

  describe 'PATCH /business/:id/unlock' do
    let!(:business) { Business.create(email: 'new_business@team04.com', password: 'Password123', name: 'A Business') }

    before do
      business.lock_access!
      expect(business.access_locked?).to eq true
    end

    context 'If the current user is authenticated as admin' do
      before { login_as(FactoryBot.create(:admin), scope: :staff) }

      it 'unlocks the account specified' do
        patch unlock_business_path(business)
        expect(business.reload.access_locked?).to eq false
      end
    end

    context 'If the current user is not authenticated as admin' do
      it 'does not unlock the account specified' do
        patch unlock_business_path(business)
        expect(business.reload.access_locked?).to eq true
      end
    end
  end

  describe 'PATCH /business/:id/invite' do
    let!(:business) { Business.create(email: 'new_business@team04.com', password: 'Password123', name: 'A Business') }

    context 'If the current user is authenticated as admin' do
      before { login_as(FactoryBot.create(:admin), scope: :staff) }

      it 'resends the invite' do
        expect(business.invitation_created_at).to eq nil
        patch invite_business_path(business)

        # Round to nearest minute
        created_at = business.reload.invitation_created_at.change({ sec: 0 })
        expect(created_at).to eq Time.now.change({ sec: 0 })
      end
    end

    context 'If the current user is not authenticated as admin' do
      it 'does not resend the invite' do
        expect(business.invitation_created_at).to eq nil
        patch invite_business_path(business)
        expect(business.invitation_created_at).to eq nil
      end
    end
  end
end
