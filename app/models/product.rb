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

  has_many :products_material, inverse_of: :product, dependent: :destroy
  has_many :materials, through: :products_material
  belongs_to :business, optional: true

  accepts_nested_attributes_for :products_material, :allow_destroy => true

  AIR = 0.570 # kgCO2/km/tonne
  SHIP = 0.014 # kgCO2/km/tonne
  SEA_PERC = 0.92 # % of the way by sea
  AIR_PERC = 0.8 # % of the way by air

  # CO2 re-calculated every time it gets updated. To update to take country into account
  def calculate_co2
    puts "Calculating CO2"
    material_co2 = materials.map(&:kg_co2_per_kg)
    material_percentages = products_material.map(&:percentage)
    if material_co2.length == material_percentages.length
      total_co2 = 0
      len = material_co2.length
      puts "Materials n: " + len.to_s
      (0..len - 1).each do |i|
        material_mass = (mass/100) * material_percentages[i]
        total_co2 += material_mass * material_co2[i]
      end
      shipping_co2 = co2_factor * mass # co2 produced from shipping
      shipping_co2 ||= 0
      self.co2_produced = total_co2 + shipping_co2 # estimated
      self.save
      puts "Total CO2 produced " + co2_produced.to_s

    end
  end

  def co2_factor
    here = Geocoder.coordinates(", , United Kingdom")
    there = Geocoder.coordinates(", , #{self.manufacturer_country}")
    distance = Geocoder::Calculations.distance_between(here, there)
    co2_factor = ((distance * SEA_PERC) * SHIP) + ((distance * AIR_PERC) * AIR) # kgCO2/tonne
    return (co2_factor / 1000) # per tonne -> per kg
  end

  def valid_material_percentages?
    if products_material.map(&:percentage).sum != 100
      errors.add(:products_material, 'Materials not totalling 100%') 
    end
  end


  # Gets the 'created_at' time truncated to the nearest hour
  def hour
    DateTime.parse(created_at.to_s).change({ min: 0, sec: 0 })
  end
end
