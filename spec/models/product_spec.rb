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
require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:material) { FactoryBot.create(:material, name: 'material', co2_per_kg: 4)}
  let!(:product) { FactoryBot.create(:product, name: 'Product', category: 'Category', manufacturer: 'Me', mass: '10', url: 'test.com', manufacturer_country: 'Country')}
  #product{described_class.new(name: 'Product', category: 'Category', manufacturer: 'Me', mass: '10', url: 'test.com', manufacturer_country: 'Country')}
  let!(:products_material) { FactoryBot.create(:products_material, product: product, material: material)}

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
    it 'is invalid without manufacturer country' do
      product.manufacturer_country = ''
      expect(product).not_to be_valid
    end
  end

  describe 'Calculates' do
    before { stub_const("Material", Material)}
    it 'CO2 produced by product' do
      ## factorybot creates association with material of 4co2/kg
      product.mass = 10     
      product.calculate_co2
      expect(product.co2_produced).to eq(40)
    end
  end
end
