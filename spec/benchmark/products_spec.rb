# frozen_string_literal: true

require 'rails_helper'

describe 'Product Page' do
  context 'Given there are 10,000 Products in the system' do
    before do
      current_time = Time.zone.now
      @category = FactoryBot.create(:category)
      example_material = FactoryBot.create(:material)
      Product.insert_all(
        10_000.times.map do |i|
          {
            name: "MyProduct #{i}",
            description: "Product Number #{i}",
            mass: rand(1..99),
            category_id: @category.id,
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
    end

    context 'As a visitor' do
      specify 'I can see the list of Products within 0.5 second of visiting the page' do
        expect do
          visit products_path
        end.to perform_under(0.5).sec
      end
      specify 'I can see the list of Products in a Category within 0.5 second of visiting the page' do
        expect do
          puts visit category_path(@category)
        end.to perform_under(0.5).sec
      end
    end
  end
end
