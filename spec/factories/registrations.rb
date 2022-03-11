# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
#
#  id         :bigint           not null, primary key
#  latitude   :float
#  longitude  :float
#  vocation   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :registration do
    longitude { 1.5 }
    latitude { 1.5 }
    vocation { 1 }
  end
end
