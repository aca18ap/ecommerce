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
#  price                :float            not null
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  business_id          :bigint
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

  describe '.hour' do
    it 'returns the "created_at" time, truncated by hour' do
      time = Time.now
      subject.created_at = time

      expect(subject.hour).to eq time.change({ min: 0, sec: 0 })
    end
  end
end
