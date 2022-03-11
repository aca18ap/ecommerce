# frozen_string_literal: true

# == Schema Information
#
# Table name: shares
#
#  id         :bigint           not null, primary key
#  feature    :string           not null
#  social     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Share, type: :model do
  subject { described_class.new(feature: 'feature1', social: 'twitter') }

  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid if feature is not present' do
      subject.feature = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid if social is not present' do
      subject.social = nil
      expect(subject).to_not be_valid
    end
  end
end
