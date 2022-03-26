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

require 'csv'

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

  SHIP = 0.014 # kgCO2/km/tonne https://www.infona.pl/resource/bwmeta1.element.baztech-article-BPW7-0024-0009/content/partContents/19bf1b47-846d-3a55-a64e-4d11b6441dc2
  SEA_PERC = 0.92 # % of the way by sea

  # CO2 re-calculated every time it gets updated. To update to take country into account
  def calculate_co2
    material_co2 = materials.map(&:kg_co2_per_kg)
    material_percentages = products_material.map(&:percentage)

    if material_co2.length == material_percentages.length
      total_co2 = 0
      len = material_co2.length
      (0..len - 1).each do |i|
        material_mass = (mass/100) * material_percentages[i]
        total_co2 += material_mass * material_co2[i]
      end

      shipping_co2 = co2_factor * mass # co2 produced from shipping
      if shipping_co2.nan?; shipping_co2 = 0 end
      puts "co2 factor" + shipping_co2.to_s


      self.co2_produced = total_co2 + shipping_co2 # estimated

    end
  end

  def co2_factor
    here = ISO3166::Country.new('GB').alpha3
    there = ISO3166::Country.new(manufacturer_country).alpha3

    csv = ::CSV.read('lib/datasets/CERDI-seadistance.csv', headers: true)
    row = csv.find { | r | (r['iso1'] == here) && (r['iso2'] == there) }
    if row.nil?; distance = 0; else distance = row['seadistance'] end

    co2_factor = distance.to_f * 1.852 * SHIP
    return (co2_factor / 1000) # per tonne -> per kg
  end

  def valid_material_percentages
    if products_material.map(&:percentage).sum != 100
      errors.add(:products_material, 'Materials not totalling 100%') 
    end
  end


  # Gets the 'created_at' time truncated to the nearest hour
  def hour
    DateTime.parse(created_at.to_s).change({ min: 0, sec: 0 })
  end
end
