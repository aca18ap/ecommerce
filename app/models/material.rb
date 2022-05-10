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
  validates :kg_co2_per_kg, numericality: { greater_than: 0 }

  has_many :products_material
  has_many :products, through: :products_material

  after_update :update_products_co2

  private

  def update_products_co2
    products.map(&:update_metrics)
    products.map(&:category).uniq.map(&:refresh_average)
  end
end
