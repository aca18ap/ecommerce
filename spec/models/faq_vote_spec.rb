# == Schema Information
#
# Table name: faq_votes
#
#  id         :bigint           not null, primary key
#  ipAddress  :string
#  value      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  faq_id     :bigint           not null
#
# Indexes
#
#  index_faq_votes_on_faq_id                (faq_id)
#  index_faq_votes_on_ipAddress_and_faq_id  (ipAddress,faq_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (faq_id => faqs.id)
#
require 'rails_helper'

RSpec.describe FaqVote, type: :model do
  let(:faq) { FactoryBot.create(:faq) }
  subject { described_class.new(ipAddress: '8.8.8.8', value: 0, faq_id: faq.id) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is valid without an IP address' do
      subject.ipAddress = nil
      expect(subject).to be_valid
    end

    it 'is valid without a value' do
      subject.value = nil
      expect(subject).to be_valid
    end

    it 'is invalid without an faq id' do
      subject.faq_id = nil
      expect(subject).not_to be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:faq) }
  end

end
