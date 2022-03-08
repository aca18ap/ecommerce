# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  hidden      :boolean          default(TRUE)
#  rank        :integer          default(0)
#  rating      :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Review, type: :model do
  subject { described_class.new(description: 'a', hidden: true, rank: 0, rating: 0) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is valid if hidden is not present' do
      subject.hidden = nil
      expect(subject).to be_valid
    end

    it 'is valid if rank is not present' do
      subject.rank = nil
      expect(subject).to be_valid
    end

    it 'is valid if rating is not present' do
      subject.rating = nil
      expect(subject).to be_valid
    end

    it 'is invalid if description is not present' do
      subject.description = nil
      expect(subject).not_to be_valid
    end
  end

  describe 'hidden_and_rank' do
    it 'should be invalid if hidden is false and rank is zero' do
      subject.hidden = false
      subject.rank = 0
      expect(subject).not_to be_valid
    end

    it 'should be invalid if hidden is true and rank is positive' do
      subject.hidden = true
      subject.rank = 1
      expect(subject).not_to be_valid
    end
  end
end
