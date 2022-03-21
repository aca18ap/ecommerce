# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BusinessDecorator do
  let(:business) { FactoryBot.create(:business).decorate }

  describe '.unlock_button?' do
    context 'when a business is locked through devise' do
      it 'should return a button to unlock their account' do
        business.lock_access!
        expect(business.unlock_button?).to have_link 'Unlock'
      end
    end

    context 'when a business is not locked through devise' do
      it 'should return nothing' do
        expect(business.unlock_button?).not_to have_link 'Unlock'
      end
    end
  end

  describe '.truncated_description' do
    context 'If a business description is under 50 characters long' do
      it 'returns the full business description' do
        business.description = 'Under 50 characters'
        expect(business.truncated_description).to eq business.description
      end
    end

    context 'If a business description is over 50 characters long' do
      it 'returns 47 characters with an ellipse if the business description is more than 50 characters long' do
        business.description = 'a' * 51
        expect(business.truncated_description).to eq "#{'a' * 47}..."
      end
    end

    context 'If a business description is nil or empty' do
      it 'returns nothing' do
        business.description = nil
        expect(business.truncated_description).to eq nil

        business.description = ''
        expect(business.truncated_description).to eq nil
      end
    end
  end

  describe '.invite_button?' do
    context 'If a business has successfully accepted an invitation' do
      it 'returns nothing' do
        business.invitation_accepted_at = Time.now
        expect(business.invite_button?).to eq nil
      end
    end

    context 'If a business was added while seeding' do
      it 'returns nothing' do
        business.invitation_accepted_at = nil
        expect(business.invite_button?).to eq nil
      end
    end

    context 'If a business has not yet accepted an invitation' do
      it 'returns a button to resend the invitation' do
        business.invite!
        business.invitation_accepted_at = nil
        expect(business.invite_button?).to have_link 'Resend'
      end
    end
  end
end
