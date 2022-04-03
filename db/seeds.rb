# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin accounts
Staff.where(email: 'admin@team04.com').first_or_create(password: 'Password123', password_confirmation: 'Password123',
                                                       role: 0)
Staff.where(email: 'reporter@team04.com').first_or_create(password: 'Password123', password_confirmation: 'Password123')

# Customer accounts
Customer.where(email: 'customer@team04.com').first_or_create(username: 'customer01', password: 'Password123',
                                                             password_confirmation: 'Password123')

# Business accounts
Business.where(email: 'business@team04.com').first_or_create(name: 'genesys', description: 'my description',
                                                             password: 'Password123',
                                                             password_confirmation: 'Password123')

# Materials
# https://www.researchgate.net/publication/276193965_Carbon_Footprint_of_Textile_and_Clothing_Products Table 7.7
Material.where(name: 'nylon').first_or_create(kg_co2_per_kg: 37)
Material.where(name: 'acrylic').first_or_create(kg_co2_per_kg: 26)
Material.where(name: 'polyester').first_or_create(kg_co2_per_kg: 19)
Material.where(name: 'polypropylene').first_or_create(kg_co2_per_kg: 17)
Material.where(name: 'viscose').first_or_create(kg_co2_per_kg: 15)
Material.where(name: 'cotton').first_or_create(kg_co2_per_kg: 8)
Material.where(name: 'wool').first_or_create(kg_co2_per_kg: 7)
Material.where(name: 'hemp').first_or_create(kg_co2_per_kg: 3)

# Products
prng = Random.new
100.times do |i|
  Product.where(name: Faker::Coffee.blend_name).first_or_create!(
    category: Faker::IndustrySegments.sub_sector,
    url: "http://www.test#{i}.com",
    description: Faker::Quotes::Shakespeare.hamlet_quote,
    manufacturer: Faker::Company.name,
    manufacturer_country: Faker::Address.country_code,
    mass: prng.rand(10.0),
    price: (prng.rand(1..200) - 0.01),
    products_material: [ProductsMaterial.new(material_id: prng.rand(1..8), percentage: 100)])
end
