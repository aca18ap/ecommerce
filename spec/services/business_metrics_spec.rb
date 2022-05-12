# frozen_string_literal: true

require 'rails_helper'

describe 'Business metrics' do
  let!(:business) { FactoryBot.create(:business) }
  let(:category) { FactoryBot.create(:category, name: 'Shirt') }
  let!(:product) { FactoryBot.create(:product, business_id: business.id) }
  let!(:product2) { FactoryBot.create(:product, url: 'https://anotherwebsite.com', business_id: business.id, category_id: category.id, name: 'testname2') }
  let(:customer) { FactoryBot.create(:customer) }

  describe '.time_affiliate_views' do
    it 'returns 0s for the last month if there are no affiliate views' do
      expected_arr = (1.month.ago.to_date..Date.today).map { |day| [day, 0] }.to_ary
      expect(BusinessMetrics.time_affiliate_views(business)).to match_array(expected_arr)
    end

    it 'returns the number of affiliate views by day if there are affiliate views' do
      [0, 1, 3].each { |x| AffiliateProductView.new(product_id: product.id, customer_id: customer.id, created_at: Date.today - x.days).save }

      expected_arr = (1.month.ago.to_date..(Date.today - 4.days)).map { |day| [day, 0] }.to_ary
      expected_arr += [[Date.today - 3.days, 1], [Date.today - 2.days, 0], [Date.today - 1.day, 1], [Date.today, 1]]

      expect(BusinessMetrics.time_affiliate_views(business)).to match_array(expected_arr)
    end
  end

  describe '.views_by_product' do
    it 'returns an empty array if there are no views or no products' do
      expect(BusinessMetrics.views_by_product(business)).to eq({})
    end

    it 'returns the number of views for each affiliate product if there are any' do
      AffiliateProductView.new(product_id: product.id, customer_id: customer.id).save
      AffiliateProductView.new(product_id: product2.id, customer_id: customer.id).save

      expect(BusinessMetrics.views_by_product(business)).to match_array([[product.name, 1], [product2.name, 1]])
    end
  end

  describe '.views_by_category' do
    it 'returns an empty array if there are no views or no products' do
      expect(BusinessMetrics.views_by_category(business)).to eq({})
    end

    it 'returns the number of views for each affiliate product if there are any' do
      AffiliateProductView.new(product_id: product.id, customer_id: customer.id).save
      AffiliateProductView.new(product_id: product2.id, customer_id: customer.id).save

      expect(BusinessMetrics.views_by_category(business)).to match_array(
        [[product.category.name, 1],
         [product2.category.name, 1]]
      )
    end
  end
end
