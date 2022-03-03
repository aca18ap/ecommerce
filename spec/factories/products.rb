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
#  type                 :string
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :product do
    name { "TestName" }
    description { "A piece of clothing" }
    mass { 1.5 }
    category { "Trousers" }
    url { "clothes.com" }
    manufacturer { "Me" }
    manufacturer_country { "UK" }
    co2_produced { 1.5 }
  end
end
