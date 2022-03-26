# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductDecorator do
  let(:product) { FactoryBot.create(:product).decorate }

  describe '.business_name' do
    let(:business) { FactoryBot.create(:business) }

    context 'If there is no business associated with a product' do
      it 'returns "Unknown"' do
        expect(product.business_name).to be 'Unknown'
      end
    end

    context 'If a business is associated with a product' do
      it 'returns the associated business name' do
        product.business_id = business.id
        expect(product.business_name).to eq business.name
      end
    end
  end

  describe '.truncated_description' do
    context 'If a product description is under 50 characters long' do
      it 'returns the full product description' do
        product.description = 'Under 50 characters'
        expect(product.truncated_description).to eq product.description
      end
    end

    context 'If a product description is over 50 characters long' do
      it 'returns 47 characters with an ellipse if the product description is more than 50 characters long' do
        product.description = 'a' * 51
        expect(product.truncated_description).to eq "#{'a' * 47}..."
      end
    end

    context 'If a product description is nil or empty' do
      it 'returns nothing' do
        product.description = nil
        expect(product.truncated_description).to eq nil

        product.description = ''
        expect(product.truncated_description).to eq nil
      end
    end
  end

  describe '.co2_produced_with_unit' do
    it 'returns the product co2 produced with "Kg" after it' do
      expect(product.co2_produced_with_unit).to eq "#{product.co2_produced}<sub>Kg</sub>"
    end
  end

  describe '.price_with_currency' do
    it 'returns the product price with a "£" symbol before it' do
      expect(product.price_with_currency).to eq "£#{product.price}"
    end
  end
end
