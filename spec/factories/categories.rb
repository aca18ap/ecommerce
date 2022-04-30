# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  ancestry    :string
#  average_co2 :float
#  mean_co2    :float            default(0.0), not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_categories_on_ancestry  (ancestry)
#
FactoryBot.define do
  factory :category do
    name { 'Trousers' }
  end
end
