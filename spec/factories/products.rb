# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                   :bigint           not null, primary key
#  co2_produced         :float
#  description          :string
#  kg_co2_per_pounds    :float
#  manufacturer         :string
#  manufacturer_country :string
#  mass                 :float
#  name                 :string
#  price                :float            default(0.0), not null
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  business_id          :bigint
#  category_id          :integer
#
# Indexes
#
#  index_products_on_business_id        (business_id)
#  index_products_on_category_id        (category_id)
#  index_products_on_co2_produced       (co2_produced)
#  index_products_on_kg_co2_per_pounds  (kg_co2_per_pounds)
#  index_products_on_name               (name)
#  index_products_on_price              (price)
#
FactoryBot.define do
  factory :product do
    name { 'TestName' }
    description { 'A piece of clothing' }
    mass { '10' }
    category { FactoryBot.build(:category) }
    url { 'https://clothes.com' }
    manufacturer { 'Me' }
    price { '10.4' }
    manufacturer_country { 'VN' }
    after :build do |product|
      product.products_material << FactoryBot.build(:products_material, material: FactoryBot.build(:material, kg_co2_per_kg: 5), percentage: 60)
      product.products_material << FactoryBot.build(:products_material, material: FactoryBot.build(:material, kg_co2_per_kg: 10), percentage: 40)
    end
  end
end
