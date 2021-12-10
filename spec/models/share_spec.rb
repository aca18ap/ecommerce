# == Schema Information
#
# Table name: shares
#
#  id         :bigint           not null, primary key
#  count      :integer
#  feature    :string
#  social     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Share, type: :model do
  subject { described_class.new(count: 0, social: 'Twitter') }

  describe 'Validates' do
    it 'is valid wit valid attributes' do
      expect(subject).to be_valid
    end

    it 'is valid if count is not present' do
      subject.count = nil
      expect(subject).to be_valid
    end

    it 'is valid if social is not present' do
      subject.social = nil
      expect(subject).to be_valid
    end
  end

end
