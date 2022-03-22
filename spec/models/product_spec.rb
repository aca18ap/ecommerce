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
require 'rails_helper'

RSpec.describe Product, type: :model do
<<<<<<< HEAD
  let!(:material) { FactoryBot.create(:material, name: 'material', kg_co2_per_kg: 4) }
  let!(:product) do
    FactoryBot.create(:product, name: 'Product', category: 'Category',
                                manufacturer: 'Me', mass: 10, price: 10.1, url: 'https://test.com', manufacturer_country: 'Country')
  end
  let!(:products_material) { FactoryBot.create(:products_material, product: product, material: material) }
=======
  let!(:material1) { FactoryBot.create(:material, name: 'material_two', kg_co2_per_kg: 4) }
  let!(:material2) { FactoryBot.create(:material, name: 'material_one', kg_co2_per_kg: 7) }
  let!(:product) { FactoryBot.create(:product, name: 'Product', category: 'Category', manufacturer: 'Me', mass: '10', url: 'test.com', manufacturer_country: 'Country') }
  let!(:products_material1) { FactoryBot.create(:products_material, product: product, material: material1, percentage: 30) }
  let!(:products_material2) { FactoryBot.create(:products_material, product: product, material: material2, percentage: 70) }
>>>>>>> tests

  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(product).to be_valid
    end

    it 'is invalid without name' do
      product.name = ''
      expect(product).not_to be_valid
    end

    it 'is invalid without category' do
      product.category = ''
      expect(product).not_to be_valid
    end

    it 'is invalid without manufacturer' do
      product.manufacturer = ''
      expect(product).not_to be_valid
    end

    it 'is invalid without mass' do
      product.mass = ''
      expect(product).not_to be_valid
    end

    it 'is invalid with a mass less than or equal to 0' do
      product.mass = 1
      expect(product).to be_valid

      product.mass = 0
      expect(product).not_to be_valid

      product.mass = -1
      expect(product).not_to be_valid
    end

    it 'is invalid without a url' do
      product.url = nil
      expect(product).not_to be_valid
    end

    it 'is invalid with an invalid url' do
      product.url = 'invalid_url'
      expect(product).not_to be_valid
    end

    it 'is invalid without manufacturer country' do
      product.manufacturer_country = ''
      expect(product).not_to be_valid
    end
  end

  describe '.calculate_co2' do
    before { stub_const('Material', Material) }
    it 'CO2 produced by product' do
      # factorybot creates association with material of 4co2/kg
      product.mass = 10
      material1.kg_co2_per_kg = 5
      material2.kg_co2_per_kg = 8
      products_material1.product = product
      products_material1.material = material1
      products_material2.product = product
      products_material2.material = material2
      products_material1.percentage = 30
      products_material2.percentage = 70
      product.calculate_co2
      puts 'materials: ' + product.materials.to_s
      expect(product.co2_produced).to eq(40)
    end
  end

  describe '.hour' do
    it 'returns the "created_at" time, truncated by hour' do
      time = Time.now
      subject.created_at = time

      expect(subject.hour).to eq time.change({ min: 0, sec: 0 })
    end
  end
end
