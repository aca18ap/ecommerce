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
#  price                :float
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  business_id          :bigint
#
class Product < ApplicationRecord
  # Scopes defined to clean up controller
  scope :filter_by_business_id, ->(business_id) { where business_id: business_id }
  scope :filter_by_similarity, ->(name) { where(name: name) }
  scope :filter_by_search_term, lambda { |name|
                                  where('name like ? OR manufacturer like ?', "#{name}%", "#{name}%")
                                }

  validates :name, :category, :url, :manufacturer, :manufacturer_country, :mass, :price, presence: true
  validates :url, uniqueness: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates :mass, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }

  before_update :calculate_co2

  has_one_attached :image, dependent: :destroy
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
