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
class Material < ApplicationRecord
  validates :name, :kg_co2_per_kg, presence: true
  has_many :products_material
  has_many :products, through: :products_material
end
