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
end
