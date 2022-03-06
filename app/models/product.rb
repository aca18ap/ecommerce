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
  validates :name, :category, :url, :manufacturer, :manufacturer_country, :co2_produced, presence: true
  validates :url, uniqueness: true

  has_many :products_material
  has_many :materials, through: :products_material
  before_create calculate_co2

  def calculate_co2
    co2_produced = 1.5
  end



end
