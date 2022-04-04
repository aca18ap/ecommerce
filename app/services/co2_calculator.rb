# frozen_string_literal: true

# Calculates the CO2 produced by a product, taking into the account materials
# and manufacturing country.
class Co2Calculator
  require 'csv'

  SHIP = 0.014 # kgCO2/km/tonne https://www.infona.pl/resource/bwmeta1.element.baztech-article-BPW7-0024-0009/content/partContents/19bf1b47-846d-3a55-a64e-4d11b6441dc2
  SEA_PERC = 0.92 # % of the way by sea

  def initialize(product)
    @materials_co2 = product.materials.map(&:kg_co2_per_kg)
    @materials_percentages = product.products_material.map(&:percentage)
    @manufacturer_country = product.manufacturer_country
    @mass = product.mass
  end

  def calculate_co2
    return unless @materials_co2.length == @materials_percentages.length

    shipping_co2 = shipping_factor * @mass # co2 produced from shipping
    shipping_co2 = 0 if shipping_co2.nil?
    (materials_factor + shipping_co2).round(2) # estimated
  end

  def materials_factor
    co2 = 0
    (0..@materials_co2.length - 1).each do |i|
      co2 += ((@mass / 100) * @materials_percentages[i]) * @materials_co2[i]
    end
    co2
  end

  def shipping_factor
    distance = calc_distance
    co2_factor = distance.to_f * 1.852 * SHIP
    (co2_factor / 1000) # per tonne -> per kg
  end

  def calc_distance
    here = ISO3166::Country.new('GB').alpha3
    there = ISO3166::Country.new(@manufacturer_country).alpha3
    csv = ::CSV.read('lib/datasets/CERDI-seadistance.csv', headers: true)
    row = csv.find { |r| (r['iso1'] == here) && (r['iso2'] == there) }
    row.nil? ? 0 : row['seadistance']
  end
end
