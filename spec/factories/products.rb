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
FactoryBot.define do
  factory :product do
    name { 'TestName' }
    description { 'A piece of clothing' }
    mass { '10' }
    category { 'Trousers' }
    url { 'https://clothes.com' }
    manufacturer { 'Me' }
    price { '10.4' }
    manufacturer_country { 'GB' }
    after :build do |product|
      product.products_material << FactoryBot.build(:products_material, material: FactoryBot.build(:material), percentage: 60)
      product.products_material << FactoryBot.build(:products_material, material: FactoryBot.build(:material), percentage: 40)
    end
  end
end
