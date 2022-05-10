# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
#
#  id         :bigint           not null, primary key
#  latitude   :float
#  longitude  :float
#  vocation   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_registrations_on_vocation  (vocation)
#
require 'rails_helper'

RSpec.describe Registration, type: :model do
  subject { described_class.new(latitude: 1.00, longitude: 1.00, vocation: Registration.vocations[:customer]) }

  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is valid without latitude' do
      subject.latitude = nil
      expect(subject).to be_valid
    end

    it 'is valid without longitude' do
      subject.longitude = nil
      expect(subject).to be_valid
    end

    it 'is invalid without a vocation' do
      subject.vocation = nil
      expect(subject).not_to be_valid
    end
  end
end
