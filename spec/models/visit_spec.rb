# == Schema Information
#
# Table name: visits
#
#  id                 :bigint           not null, primary key
#  csrf_token         :string
#  from               :datetime
#  latitude           :float
#  longitude          :float
#  path               :string
#  session_identifier :string
#  to                 :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#
require 'rails_helper'

RSpec.describe Visit, type: :model do
  subject { described_class.new(csrf_token: 'a', latitude: 0.0, longitude: 0.0, path: '/', session_identifier: 'b', from: DateTime.now, to: DateTime.now + 1) }

  describe 'Validation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is valid without a csrf_token' do
      subject.csrf_token = nil
      expect(subject).to be_valid
    end

    it 'is valid without a latitude' do
      subject.latitude = nil
      expect(subject).to be_valid
    end

    it 'is valid without a longitude' do
      subject.longitude = nil
      expect(subject).to be_valid
    end

    it 'is valid without a path' do
      subject.path = nil
      expect(subject).to be_valid
    end

    it 'is valid without a session_identifier' do
      subject.session_identifier = nil
      expect(subject).to be_valid
    end

    it 'is valid without a from time' do
      subject.from = nil
      expect(subject).to be_valid
    end

    it 'is valid without a to time' do
      subject.to = nil
      expect(subject).to be_valid
    end
  end
end
