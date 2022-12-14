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

FactoryBot.define do
  factory :business do
    email { 'business@team04.com' }
    password { 'Password123' }
    name { 'MyBusiness' }
    description { 'MyBusinessDescription' }
  end
end
