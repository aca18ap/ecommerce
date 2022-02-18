# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDecorator do
  let(:locked) { FactoryBot.create(:locked).decorate }
  let(:customer) { FactoryBot.create(:customer).decorate }

  describe '.unlock_button?' do
    context 'when a user has an "unlock token" in their database entry' do
      it 'should return a button to unlock their account' do
        expect(locked.unlock_button?).to have_link 'Unlock'
      end
    end

    context 'when a user doesn\'t have an "unlock token" in their database entry' do
      it 'should return nothing' do
        expect(customer.unlock_button?).not_to have_link 'Unlock'
      end
    end
  end
end
