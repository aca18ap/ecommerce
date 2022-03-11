# frozen_string_literal: true

# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :text
#  clicks     :integer          default(0), not null
#  hidden     :boolean
#  question   :text             not null
#  usefulness :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Faq, type: :model do
  subject { described_class.new(answer: 'a', question: 'b', hidden: false, usefulness: 0, clicks: 0) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a question' do
      subject.question = nil
      expect(subject).not_to be_valid
    end

    it 'is valid without a answer' do
      subject.answer = nil
      expect(subject).to be_valid
    end

    it 'is valid without usefulness' do
      subject.usefulness = nil
      expect(subject).to be_valid
    end

    it 'is valid without clicks' do
      subject.clicks = nil
      expect(subject).to be_valid
    end
  end
end
