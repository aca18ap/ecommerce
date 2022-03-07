# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomerDecorator do
  let(:customer) { FactoryBot.create(:customer).decorate }

  describe '.unlock_button?' do
    context 'when a customer is locked through devise' do
      it 'should return a button to unlock their account' do
        customer.lock_access!
        expect(customer.unlock_button?).to have_link 'Unlock'
      end
    end

    context 'when a customer is not locked through devise' do
      it 'should return nothing' do
        expect(customer.unlock_button?).not_to have_link 'Unlock'
      end
    end
  end
end
