# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletters
#
#  id         :bigint           not null, primary key
#  email      :string
#  latitude   :float
#  longitude  :float
#  tier       :string
#  vocation   :string           default("Customer"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Newsletter, type: :model do
  let!(:newsletter) { FactoryBot.create(:newsletter) }
  subject do
    described_class.new(email: 'email@email.com', latitude: 0, longitude: 0, tier: 'Free', vocation: 'Customer')
  end

  describe 'Validation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without an email' do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it 'is invalid if the email is not unique' do
      subject.email = newsletter.email
      expect(subject).not_to be_valid
    end

    it 'is invalid if the email does not meet the expected regex' do
      subject.email = 'invalid_email'
      expect(subject).not_to be_valid
      expect(subject).not_to be_valid
    end

    it 'is valid if longitude is not present' do
      subject.longitude = nil
      expect(subject).to be_valid
    end

    it 'is valid if latitude is not present' do
      subject.latitude = nil
      expect(subject).to be_valid
    end

    it 'is valid if tier is not present' do
      subject.tier = nil
      expect(subject).to be_valid
    end

    it 'is valid if vocation is not present and vocation is set to customer by default' do
      subject.longitude = nil
      expect(subject).to be_valid
      expect(subject.vocation).to eq('Customer')
    end
  end
end
