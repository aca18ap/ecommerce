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
    faq = Faq.new(answer: 'a', question: 'b', hidden: false, usefulness: 0)
    expect(faq).to be_valid
  end

  it 'is not valid without a question' do
    faq = Faq.new(answer: 'a', question: nil, hidden: false, usefulness: 0)
    expect(faq).not_to be_valid
  end



end
