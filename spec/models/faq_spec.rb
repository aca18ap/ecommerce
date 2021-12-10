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
  it 'is valid with valid attributes' do
    faq = Faq.new(answer: 'a', question: 'b', hidden: false, usefulness: 0, created_at: '2021-11-27 16:39:22', updated_at: '2021-11-27 16:39:22')
    expect(faq).to be_valid
  end

  it 'is not valid without a question' do
    faq = Faq.new(answer: 'a', question: 'b', hidden: false, usefulness: 0, created_at: '2021-11-27 16:39:22', updated_at: '2021-11-27 16:39:22')
    expect(faq).not_to be_valid
  end

  it 'is not valid without created_at' do
    faq = Faq.new(answer: 'a', question: 'b', hidden: false, usefulness: 0, created_at: '2021-11-27 16:39:22', updated_at: '2021-11-27 16:39:22')
    expect(faq).not_to be_valid
  end

  it 'is not valid without updated_at' do
    faq = Faq.new(answer: 'a', question: 'b', hidden: false, usefulness: 0, created_at: '2021-11-27 16:39:22', updated_at: '2021-11-27 16:39:22')
    expect(faq).not_to be_valid
  end

  it 'is not valid without created_at' do
    faq = Faq.new(answer: 'a', question: 'b', hidden: false, usefulness: 0, created_at: '2021-11-27 16:39:22', updated_at: '2021-11-27 16:39:22')
    expect(faq).not_to be_valid
  end


end
