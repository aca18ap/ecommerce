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
#
FactoryBot.define do
  factory :product do
    name { "TestName" }
    description { "A piece of clothing" }
    mass { "14" }
    category { "Trousers" }
    url { "clothes.com" }
    manufacturer { "Me" }
    manufacturer_country { "Italy" }
  end
  factory :invalid_product do
    name { "" }
    description { "A piece of clothing" }
    mass { "14" }
    category { "Trousers" }
    url { "clothes.com" }
    manufacturer { "Me" }
    manufacturer_country { "Italy" }
  end
end
