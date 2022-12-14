# frozen_string_literal: true

# == Schema Information
#
# Table name: customers
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  suspended              :boolean          default(FALSE), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_customers_on_confirmation_token    (confirmation_token) UNIQUE
#  index_customers_on_email                 (email) UNIQUE
#  index_customers_on_reset_password_token  (reset_password_token) UNIQUE
#  index_customers_on_unlock_token          (unlock_token) UNIQUE
#  index_customers_on_username              (username) UNIQUE
#
require 'rails_helper'

RSpec.describe Customer, type: :model do
  let!(:customer) { FactoryBot.create(:customer) }
  subject { described_class.new(email: 'new_customer@team04.com', password: 'Password123', username: 'MyNewUsername') }

  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without an email' do
      subject.email = ''
      expect(subject).not_to be_valid
    end

    it 'is invalid if an email is already being used' do
      subject.email = customer.email
      expect(subject).not_to be_valid
    end

    it 'is invalid without a username' do
      subject.username = nil
      expect(subject).not_to be_valid
    end

    it 'is invalid if a username is already being used' do
      subject.username = customer.username
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

    it 'is valid without suspended status' do
      subject.suspended = nil
      expect(subject).to be_valid
    end
  end
end
