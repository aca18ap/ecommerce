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
FactoryBot.define do
  factory :newsletter do
    email { 'new_customer@team04.com' }
    created_at { '2021-11-27 16:39:22' }
    vocation { 'Customer' }
    tier { 'Free' }
  end
end
