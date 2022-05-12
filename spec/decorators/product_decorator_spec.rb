# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductDecorator do
  let(:product) { FactoryBot.create(:product).decorate }
  let(:affiliate_product) { FactoryBot.create(:product, url: 'https://different-url.com', business_id: 1).decorate }

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

  describe '.truncated_name' do
    context 'If a product name is under 50 characters long' do
      it 'returns the full product name' do
        product.name = 'Under 50 characters'
        expect(product.truncated_name).to eq product.name
      end
    end

    context 'If a product name is over 50 characters long' do
      it 'returns 47 characters with an ellipse if the product name is more than 50 characters long' do
        product.name = 'a' * 51
        expect(product.truncated_name).to eq "#{'a' * 47}..."
      end
    end

    context 'If a product name is nil or empty' do
      it 'returns nothing' do
        product.name = nil
        expect(product.truncated_name).to eq nil

        product.name = ''
        expect(product.truncated_name).to eq nil
      end
    end
  end

  describe '.co2_produced_with_unit' do
    it 'returns the product co2 produced with "kg of CO2" after it' do
      expect(product.co2_produced_with_unit).to eq "#{product.co2_produced}<sub>Kg of CO2</sub>"
    end
  end

  describe '.price_with_currency' do
    it 'returns the product price with a "£" symbol before it' do
      expect(product.price_with_currency).to eq "£#{product.price}"
    end
  end

  describe '.product_image' do
    it 'returns the image product if exists' do
      product.image.attach(
        io: File.open(Rails.root.join('spec', 'assets', 'footprint.jpg')),
        filename: 'footprint.jpg',
        content_type: 'image/jpeg'
      )
      expect(product.product_image).to have_css("img[src*='footprint']")
    end

    it 'returns the default image if none\' attached' do
      expect(product.product_image).to have_css("img[src*='default-image']")
    end
  end

  describe '.materials_breakdown' do
    it 'returns a list of materials with their percentages' do
      expect(product.materials_breakdown).to have_content('Timber', count: 2)
      expect(product.materials_breakdown).to have_content '60%'
      expect(product.materials_breakdown).to have_content '40%'
    end
  end

  describe '.mass_with_unit' do
    it 'returns the mass with kg symbol' do
      expect(product.mass_with_unit).to eq '10.0 kg'
    end
  end

  describe '.co2_per_pound' do
    it 'returns the co2 produced per pound' do
      expect(product.co2_per_pound).to eq(7.15)
    end
  end

  describe '.number_of_views' do
    let(:customer) { FactoryBot.create(:customer) }

    it 'returns 0 if the product is not an affiliate product' do
      expect(product.number_of_views).to eq '0 Views'
    end

    it 'returns "1 View" if the product has been viewed once' do
      AffiliateProductView.new(product_id: affiliate_product.id, customer_id: customer.id).save
      expect(affiliate_product.number_of_views).to eq '1 View'
    end

    it 'returns "N Views" if the product has been viewed once' do
      10.times do
        AffiliateProductView.new(product_id: affiliate_product.id, customer_id: customer.id).save
      end

      expect(affiliate_product.number_of_views).to eq '10 Views'
    end
  end

  describe '.full_country_name' do
    it 'returns the full country name of a product' do
      expect(product.full_country_name).to eq 'Vietnam'
    end
  end

  describe '.difference_with_mean' do
    it 'returns how much co2 is saved than the avg product' do
      calc = (product.category.mean_co2 - product.co2_produced).round(2)
      expect(product.difference_with_mean).to eq(calc)
    end
  end

  describe '.difference_formatted' do
    it 'returns the difference with mean with unit' do
      expect(product.difference_formatted).to eq("#{product.difference_with_mean}<sub>Kg of CO2</sub>")
    end
  end

  describe '.co2_in_car_km' do
    it 'returns how much co2 was saved in kilometers driven by car' do
      km = (product.difference_with_mean / 0.099).round(2)
      expect(product.co2_in_car_km).to eq("#{km}<sub>km</sub>")
    end
  end
end
