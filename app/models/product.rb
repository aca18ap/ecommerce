# == Schema Information
#
# Table name: products
#
#  id                   :bigint           not null, primary key
#  co2_produced         :float
#  description          :string
#  manufacturer         :string
#  manufacturer_country :string
#  mass                 :float
#  name                 :string
#  category             :string
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Product < ApplicationRecord
<<<<<<< HEAD
  validates :name, :category, :url, :manufacturer, :manufacturer_country, :mass, presence: true
  validates :url, uniqueness: true
  before_update :calculate_co2

  has_many :products_material, dependent: :destroy
  has_many :materials, through: :products_material

  ##CO2 re-calculated every time it gets updated. To update to take country into account
  def calculate_co2
    tmp_co2 = 0
    self.materials.each do |m|
      tmp_co2 += m.co2_per_kg
    end
    self.co2_produced = ( self.mass * tmp_co2).round(2)

  end
=======
  validates :name, :type, :url, :manufacturer, :manufacturer_country,  presence: true
  validates :url, uniqueness: true

  
>>>>>>> model validation

end
