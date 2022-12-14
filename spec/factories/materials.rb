# frozen_string_literal: true

# == Schema Information
#
# Table name: materials
#
#  id            :bigint           not null, primary key
#  kg_co2_per_kg :float
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :material do
    name { 'Timber' }
    kg_co2_per_kg { 4 }
  end
end
