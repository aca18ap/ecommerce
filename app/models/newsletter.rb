# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletters
#
#  id         :bigint           not null, primary key
#  email      :string
#  latitude   :float
#  longitude  :float
#  tier       :string
#  vocation   :string           default("Customer"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Newsletter < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
