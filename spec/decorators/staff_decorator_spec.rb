# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaffDecorator do
  let(:staff) { FactoryBot.create(:admin).decorate }

  describe '.unlock_button?' do
    context 'when a staff member is locked through devise' do
      it 'should return a button to unlock their account' do
        staff.lock_access!
        expect(staff.unlock_button?).to have_link 'Unlock'
      end
    end

    context 'when a staff member is not locked through devise' do
      it 'should return nothing' do
        expect(staff.unlock_button?).not_to have_link 'Unlock'
      end
    end
  end

  describe '.invite_button?' do
    context 'If a staff member has successfully accepted an invitation' do
      it 'returns nothing' do
        staff.invitation_accepted_at = Time.now
        expect(staff.invite_button?).to eq nil
      end
    end

    context 'If a staff member was added while seeding' do
      it 'returns nothing' do
        staff.invitation_accepted_at = nil
        expect(staff.invite_button?).to eq nil
      end
    end

    context 'If a staff member has not yet accepted an invitation' do
      it 'returns a button to resend the invitation' do
        staff.invite!
        staff.invitation_accepted_at = nil
        expect(staff.invite_button?).to have_link 'Resend'
      end
    end
  end
end
