# frozen_string_literal: true

# == Schema Information
#
# Table name: businesses
#
#  id                     :bigint           not null, primary key
#  description            :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  locked_at              :datetime
#  name                   :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_businesses_on_email                 (email) UNIQUE
#  index_businesses_on_invitation_token      (invitation_token) UNIQUE
#  index_businesses_on_invited_by            (invited_by_type,invited_by_id)
#  index_businesses_on_invited_by_id         (invited_by_id)
#  index_businesses_on_reset_password_token  (reset_password_token) UNIQUE
#  index_businesses_on_unlock_token          (unlock_token) UNIQUE
#
require 'rails_helper'

RSpec.describe Business, type: :model do
  let!(:business) { FactoryBot.create(:business) }
  subject { described_class.new(email: 'new_business@team04.com', password: 'Password123', name: 'MyNewBusiness', description: 'MyNewBusinessDescription') }

  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without an email' do
      subject.email = ''
      expect(subject).not_to be_valid
    end

    it 'is invalid if an email is already being used' do
      subject.email = business.email
      expect(subject).not_to be_valid
    end

    it 'is valid without a name' do
      subject.name = nil
      expect(subject).to be_valid
    end

    it 'is valid if the name is already being used' do
      subject.name = business.name
      expect(subject).to be_valid
    end

    it 'is valid without a description' do
      subject.description = nil
      expect(subject).to be_valid
    end

    it 'is invalid without a password' do
      subject.password = nil
      expect(subject).not_to be_valid
    end

    it 'is invalid if the password is less than 8 characters' do
      subject.password = 'Small1'
      expect(subject).not_to be_valid
    end

    it 'is invalid if the password is longer than 128 characters' do
      # Generate a 129 character string that meets the other password requirements
      subject.password = "1A#{'a' * 127}"
      expect(subject).not_to be_valid
    end

    it 'is invalid if the password does not contain at least one capital letter, one lower-case letter and one number' do
      # No numbers
      subject.password = 'NoNumbers'
      expect(subject).not_to be_valid

      # No upper-case
      subject.password = 'nouppercase1'
      expect(subject).not_to be_valid

      # No lower-case
      subject.password = 'NOLOWERCASE1'
      expect(subject).not_to be_valid
    end

    it 'does not store a plaintext password' do
      expect(subject.encrypted_password).not_to eq('Password123')
    end
  end
end
