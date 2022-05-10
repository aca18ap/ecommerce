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
require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:product) { FactoryBot.create(:product) }

  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(product).to be_valid
    end

    it 'is invalid without name' do
      product.name = ''
      expect(product).not_to be_valid
    end

    it 'is invalid without category' do
      product.category_id = ''
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
    it 'is invalid if materials dont add up to 100%' do
      product.products_material[0].percentage = 0
      expect(product).not_to be_valid
    end
  end

  describe '.calculate_co2' do
    before { stub_const('Material', Material) }
    it 'CO2 produced by product' do
      product.manufacturer_country = 'GB' # gb = Great Britain, same as country of origin, thus co2=70
      product.save
      expect(product.reload.co2_produced).to eq(70)
    end

    it 'CO2 increases when country is further' do
      product.manufacturer_country = 'VN' # VN = Vietnam, far from GB
      expect(product.reload.co2_produced).to be > 70
    end
  end
end
