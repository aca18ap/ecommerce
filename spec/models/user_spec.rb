# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
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
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string           default("customer"), not null
#  sign_in_count          :integer          default(0), not null
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by            (invited_by_type,invited_by_id)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:reporter) { FactoryBot.create(:reporter) }
  subject { described_class.new(email: 'customer@team04.com', admin: false, role: 'customer', password: 'Password123') }

  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without an email' do
      subject.email = ''
      expect(subject).not_to be_valid
    end

    it 'is invalid if an email is already being used' do
      subject.email = 'reporter@team04.com'
      expect(subject).not_to be_valid
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

    it 'is valid if admin is not present' do
      subject.admin = nil
      expect(subject).to be_valid
    end

    it 'is valid if role is not present' do
      subject.role = nil
      expect(subject).to be_valid
    end
  end
end
