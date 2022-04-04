# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomerDecorator do
  let!(:customer) { FactoryBot.create(:customer).decorate }
  let!(:customer2) { FactoryBot.create(:customer, email: 'newcustomer@team04.com', username: 'another').decorate }
  let!(:product) { FactoryBot.create(:product) }
  let!(:product2) { FactoryBot.create(:product, url: 'https://anotherwebsite.com', price: 5.7) }

  # Cannot insert elements into purchase history using decorated classes for some reason
  def insert_purchases
    Customer.find(customer.id).products << product
    Customer.find(customer2.id).products << product2
  end

  describe '.unlock_button?' do
    context 'when a customer is locked through devise' do
      it 'should return a button to unlock their account' do
        customer.lock_access!
        expect(customer.unlock_button?).to have_link 'Unlock'
      end
    end

    context 'when a customer is not locked through devise' do
      it 'should return nothing' do
        expect(customer.unlock_button?).not_to have_link 'Unlock'
      end
    end
  end

  describe '.mean_co2_per_purchase' do
    it 'returns "N/A" if a customer has no products in their purchase history' do
      expect(customer.mean_co2_per_purchase).to eq({ customer: 'N/A', site: 0, valence: 'average' })
    end

    it 'returns the mean CO2, rounded to one decimal place if there are purchases in their history' do
      insert_purchases

      site_mean = ((product.co2_produced + product2.co2_produced) / 2).round(1)
      expect(customer.mean_co2_per_purchase).to eq({ customer: product.co2_produced.round(1), site: site_mean, valence: 'average' })
    end
  end

  describe '.total_co2_produced' do
    it 'returns "N/A" if a customer has no products in their purchase history' do
      expect(customer.total_co2_produced).to eq({ customer: 'N/A', site: 0, valence: 'average' })
    end

    it 'returns the total CO2, rounded to one decimal place if there are purchases in their history' do
      insert_purchases

      site_mean = ((product.co2_produced + product2.co2_produced) / 2).round(1)
      expect(customer.total_co2_produced).to eq({ customer: product.co2_produced.round(1), site: site_mean, valence: 'average' })
    end
  end

  describe '.co2_saved' do
    it 'returns "N/A" if a customer has no products in their purchase history' do
      expect(customer.total_co2_produced).to eq({ customer: 'N/A', site: 0, valence: 'average' })
    end

    it 'returns the total CO2 saved, rounded to one decimal place if there are purchases in their history' do
      skip 'Needs implementing'
    end
  end

  describe '.co2_per_pound' do
    it 'returns "N/A" if a customer has no products in their purchase history' do
      expect(customer.co2_per_pound).to eq({ customer: 'N/A', site: 0, valence: 'average' })
    end

    it 'returns the CO2 per pound, rounded to one decimal place if there are purchases in their history' do
      insert_purchases

      customer_mean = (product.co2_produced / product.price).round(1)
      site_mean = ((product.co2_produced + product2.co2_produced) / (product.price + product2.price)).round(1)
      expect(customer.co2_per_pound).to eq({ customer: customer_mean, site: site_mean, valence: 'good' })
    end
  end
end
