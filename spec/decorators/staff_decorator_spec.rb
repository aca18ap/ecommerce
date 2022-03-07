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
end
