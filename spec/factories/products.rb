FactoryBot.define do
  factory :product do
    name { "MyString" }
    description { "MyString" }
    mass { 1.5 }
    type { "" }
    url { "MyString" }
    manufacturer { "MyString" }
    manufacturer_country { "MyString" }
    co2_produced { 1.5 }
  end
end
