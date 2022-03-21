# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                   :bigint           not null, primary key
#  category             :string
#  co2_produced         :float
#  description          :string
#  manufacturer         :string
#  manufacturer_country :string
#  mass                 :float
#  name                 :string
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  business_id          :bigint
#
class Product < ApplicationRecord
  # Scopes defined to clean up controller
  scope :filter_by_business, ->(business_id) { where business_id: business_id }
  scope :filter_by_similarity, ->(name) { where('name like ?', "#{name}%") }
  scope :filter_by_query, ->(name) { where('name like ?', "#{name}%") }

  validates :name, :category, :url, :manufacturer, :manufacturer_country, :mass, presence: true
  validates :url, uniqueness: true
  before_update :calculate_co2

  has_many :products_material, dependent: :destroy
  has_many :materials, through: :products_material
  belongs_to :business, optional: true

  # CO2 re-calculated every time it gets updated. To update to take country into account
  def calculate_co2
    material_co2 = materials.map(&:kg_co2_per_kg).sum
    self.co2_produced = (mass * material_co2).round(2)
  end

  # Gets the 'created_at' time truncated to the nearest hour
  def hour
    DateTime.parse(created_at.to_s).change({ min: 0, sec: 0 })
  end
end
