# frozen_string_literal: true

require 'rails_helper'

describe 'Business metrics' do
  let!(:business) { FactoryBot.create(:business) }
  let!(:product) { FactoryBot.create(:product, business_id: business.id) }
  let!(:product2) { FactoryBot.create(:product, url: 'https://anotherwebsite.com', business_id: business.id, category: 'Shirt') }
  let(:customer) { FactoryBot.create(:customer) }

  describe '.time_affiliate_views' do
    it 'returns nil if there are no affiliate views' do
      expect(BusinessMetrics.time_affiliate_views(business)).to eq nil
    end

    it 'returns the number of affiliate views by day if there are affiliate views' do
      a = AffiliateProductView.new(product_id: product.id, customer_id: customer.id, created_at: Time.now - 2.days)
      a.save
      b = AffiliateProductView.new(product_id: product2.id, customer_id: customer.id, created_at: Time.now)
      b.save

      expect(BusinessMetrics.time_affiliate_views(business)).to match_array(
        [{ 'time' => a.created_at.change({ hour: 0, min: 0, sec: 0 }).to_i, 'value' => 1 },
         { 'time' => (b.created_at.change({ hour: 0, min: 0, sec: 0 }) - 1.day).to_i, 'value' => 0 },
         { 'time' => b.created_at.change({ hour: 0, min: 0, sec: 0 }).to_i, 'value' => 1 }]
      )
    end
  end

  describe '.views_by_product' do
    it 'returns an empty array if there are no views or no products' do
      expect(BusinessMetrics.views_by_product(business)).to eq []
    end

    it 'returns the number of views for each affiliate product if there are any' do
      AffiliateProductView.new(product_id: product.id, customer_id: customer.id).save
      AffiliateProductView.new(product_id: product2.id, customer_id: customer.id).save

      expect(BusinessMetrics.views_by_product(business)).to match_array(
        [{ 'name' => "#{product.name} (#{product.id})", 'count' => 1 },
         { 'name' => "#{product2.name} (#{product2.id})", 'count' => 1 }]
      )
    end
  end

  describe '.views_by_category' do
    it 'returns an empty array if there are no views or no products' do
      expect(BusinessMetrics.views_by_category(business)).to eq []
    end

    it 'returns the number of views for each affiliate product if there are any' do
      AffiliateProductView.new(product_id: product.id, customer_id: customer.id).save
      AffiliateProductView.new(product_id: product2.id, customer_id: customer.id).save

      expect(BusinessMetrics.views_by_category(business)).to match_array(
        [{ 'category' => product.category, 'count' => 1 },
         { 'category' => product2.category, 'count' => 1 }]
      )
    end
  end
end
