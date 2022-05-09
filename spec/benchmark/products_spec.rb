# frozen_string_literal: true

require 'rails_helper'

describe 'Product Page' do
  context 'Given there are 10,000 Products in the system' do
    before do
      current_time = Time.zone.now
      category = FactoryBot.build(:category)
      example_material = FactoryBot.create(:material)
      #
      product_ids = Product.insert_all(
        10_000.times.map do |i|
          {
            name: "MyProduct #{i}",
            description: "Product Number #{i}",
            mass: rand(1..99),
            category_id: category.id,
            url: 'https://clothes.com',
            manufacturer: 'Me',
            price: rand(1..99),
            manufacturer_country: 'VN',
            created_at: current_time,
            updated_at: current_time
          }
        end, returning: %w[id]
      )
      Product.all.each do |p|
        p.products_material << FactoryBot.build(:products_material, material: example_material, percentage: rand(1..99))
      end
      # ProductsMaterial.insert_all(
      #   product_ids.map do |i|
      #     {
      #       product_id: i['id'],
      #       material_id: example_material.id,
      #       percentage: rand(1..99),
      #       created_at: current_time,
      #       updated_at: current_time
      #     }
      #   end
      # )
    end

    context 'As a visitor' do
      specify 'I can see the list of Products within 0.5 second of visiting the page' do
        expect {
          visit products_path
        }.to perform_under(0.5).sec
      end
    end
  end
end
