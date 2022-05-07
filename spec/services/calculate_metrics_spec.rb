# frozen_string_literal: true

require 'rails_helper'

describe 'Calculating metrics' do
  let(:business) { FactoryBot.create(:business) }

  let(:category) { FactoryBot.create(:category, name: 'shoes') }
  let(:category2) { FactoryBot.create(:category, name: 'shirt') }

  describe '.product_categories' do
    it 'returns an empty array if there are no products in the system' do
      expect(CalculateMetrics.product_categories).to eq({})
    end

    it 'returns the number of products, grouped by category' do
      n1 = 3
      n2 = 5
      n1.times { |x| FactoryBot.create(:product, url: "https://category_1_#{x}.com", category_id: category.id) }
      n2.times { |x| FactoryBot.create(:product, url: "https://category_2_#{x}.com", category_id: category2.id) }

      expect(CalculateMetrics.product_categories).to match_array([[category.name, n1], [category2.name, n2]])
    end
  end

  describe '.time_product_additions' do
    it 'returns an empty array if there are no products in the system' do
      expect(CalculateMetrics.time_product_additions).to eq({})
    end

    it 'returns the number of products per day' do
      [0, 1, 3].each { |x| FactoryBot.create(:product, url: "https://test_#{x}.com", created_at: Date.today - x.days) }

      expect(CalculateMetrics.time_product_additions).to match_array([[Date.today - 3.days, 1],
                                                                      [Date.today - 2.days, 0],
                                                                      [Date.today - 1.day, 1],
                                                                      [Date.today, 1]])
    end
  end

  describe '.affiliate_categories' do
    it 'returns an empty array if there are no affiliate products' do
      expect(CalculateMetrics.affiliate_categories).to eq({})
    end

    it 'returns the number of affiliate products for each category' do
      n1 = 3
      n2 = 5
      n1.times { |x| FactoryBot.create(:product, url: "https://category_1_#{x}.com", category_id: category.id, business_id: business.id) }
      n2.times { |x| FactoryBot.create(:product, url: "https://category_2_#{x}.com", category_id: category2.id, business_id: business.id) }

      expect(CustomerMetrics.affiliate_categories).to match_array([[category.name, n1], [category2.name, n2]])
    end
  end

  describe '.time_affiliate_views' do
    let(:customer) { FactoryBot.create(:customer) }
    let(:product) { FactoryBot.create(:product, business_id: business.id) }

    it 'returns an empty array if there are no affiliate views or affiliate products' do
      expect(CalculateMetrics.time_affiliate_views).to eq({})
    end

    it 'gets the number of affiliate views per day' do
      [0, 1, 3].each { |x| AffiliateProductView.new(product_id: product.id, customer_id: customer.id, created_at: Date.today - x.days).save }

      expect(CalculateMetrics.time_affiliate_views).to match_array([[Date.today - 3.days, 1],
                                                                    [Date.today - 2.days, 0],
                                                                    [Date.today - 1.day, 1],
                                                                    [Date.today, 1]])
    end
  end

  describe '.visits_by_page' do
    it 'returns an empty array if there are no visits in the system' do
      expect(CalculateMetrics.visits_by_page).to eq({})
    end

    it 'returns the number of visits by page' do
      n1 = 3
      n2 = 5
      n1.times { FactoryBot.create(:visit, path: '/') }
      n2.times { FactoryBot.create(:visit, path: '/reviews') }

      expect(CalculateMetrics.visits_by_page).to match_array([['/', n1], ['/reviews', n2]])
    end
  end

  describe '.time_visits' do
    it 'returns an empty array if there are no visits in the system' do
      expect(CalculateMetrics.time_visits).to eq({})
    end

    it 'returns the number of visit per day if there' do
      [0, 1, 3].each { |x| FactoryBot.create(:visit, from: Date.today - x.days) }

      expect(CalculateMetrics.time_visits).to match_array([[Date.today - 3.days, 1],
                                                           [Date.today - 2.days, 0],
                                                           [Date.today - 1.day, 1],
                                                           [Date.today, 1]])
    end
  end

  describe '.vocation_registrations' do
    it 'returns an empty array if there are no registrations in the system' do
      expect(CalculateMetrics.vocation_registrations).to eq({})
    end

    it 'returns the number of registrations, grouped by vocation' do
      n1 = 3
      n2 = 5
      n1.times { Registration.new(vocation: Registration.vocations[:customer]).save }
      n2.times { Registration.new(vocation: Registration.vocations[:business]).save }

      expect(CalculateMetrics.vocation_registrations).to match_array([['customer', n1], ['business', n2]])
    end
  end

  describe '.time_registrations' do
    it 'returns an empty array if there are no registrations in the system' do
      expect(CalculateMetrics.time_registrations).to eq({})
    end

    it 'returns the number of registrations each day' do
      [0, 1, 3].each { |x| Registration.new(vocation: Registration.vocations[:customer], created_at: Date.today - x.days).save }

      expect(CalculateMetrics.time_registrations).to match_array([[Date.today - 3.days, 1],
                                                                  [Date.today - 2.days, 0],
                                                                  [Date.today - 1.day, 1],
                                                                  [Date.today, 1]])
    end
  end

  describe '.feature_interest' do
    it 'returns an empty array if there are no shares in the system' do
      expect(CalculateMetrics.feature_interest).to eq({})
    end

    it 'gets the number of times a feature is share to which social network' do
      n1 = 3
      n2 = 5

      n1.times do
        FactoryBot.create(:share, feature: 'Feature2', social: 'email')
        FactoryBot.create(:share, feature: 'Feature1', social: 'twitter')
        FactoryBot.create(:share, feature: 'Feature2', social: 'facebook')
      end

      n2.times do
        FactoryBot.create(:share, feature: 'Feature1', social: 'email')
        FactoryBot.create(:share, feature: 'Feature2', social: 'twitter')
        FactoryBot.create(:share, feature: 'Feature1', social: 'facebook')
      end

      expect(CalculateMetrics.feature_interest).to match_array(
        [[%w[Feature1 email], n2],
         [%w[Feature1 twitter], n1],
         [%w[Feature1 facebook], n2],
         [%w[Feature2 email], n1],
         [%w[Feature2 twitter], n2],
         [%w[Feature2 facebook], n1]]
      )
    end
  end

  describe '.session_flows' do
    it 'returns an empty array if there are no visits in the system' do
      skip 'Needs reworking'
      expect(CalculateMetrics.session_flows).to eq({})
    end

    it 'returns the path users take throughout the system and whether they registered on that path' do
      skip 'Needs reworking'
      expect(CalculateMetrics.session_flows(visits)).to match_array(
                                                          [{ 'id' => visit_root.session_identifier, 'flow' => [visit_root], 'registered' => false },
                                                           { 'id' => visit_reviews.session_identifier, 'flow' => [visit_reviews], 'registered' => false },
                                                           { 'id' => visit_newsletters.session_identifier, 'flow' => [visit_newsletters], 'registered' => true }]
                                                        )
    end
  end
end
