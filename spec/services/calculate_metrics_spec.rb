# frozen_string_literal: true

require 'rails_helper'

describe 'Calculating metrics' do
  # Visits
  let(:visit_root) { FactoryBot.create(:visit, path: '/', session_identifier: 'Session1') }
  let(:visit_reviews) { FactoryBot.create(:visit, path: '/reviews', session_identifier: 'Session2') }
  let(:visit_newsletters) { FactoryBot.create(:visit, path: '/newsletters/1', session_identifier: 'Session3') }

  # Registrations
  let(:customer_registration) { FactoryBot.create(:customer_registration) }
  let(:customer_registration2) { FactoryBot.create(:customer_registration) }
  let(:business_registration) { FactoryBot.create(:business_registration) }

  # Category
  let(:category) { FactoryBot.create(:category, name: 'shoes') }
  let(:category2) { FactoryBot.create(:category, name: 'shirt') }

  # Products
  let!(:product1) { FactoryBot.create(:product, created_at: '2021-11-27 16:39:22', category_id: category.id) }
  let!(:product2) { FactoryBot.create(:product, created_at: '2021-11-27 16:39:22', url: 'https://something.com', category_id: category2.id) }
  let!(:product3) { FactoryBot.create(:product, created_at: Time.now, url: 'https://somethingelse.com', category_id: category2.id) }

  let(:visits) { [visit_root, visit_reviews, visit_newsletters] }
  let(:regs) { [customer_registration, customer_registration2, business_registration] }
  let(:products) { [product1, product2, product3] }

  it 'Calculates visits to each site page' do
    expect(CalculateMetrics.page_visits(visits)).to match_array([{ 'page' => '/', 'visits' => 1 },
                                                                 { 'page' => '/reviews', 'visits' => 1 },
                                                                 { 'page' => '/newsletters/1', 'visits' => 1 }])
  end

  it 'Calculates the number of registrations by vocation' do
    expect(CalculateMetrics.vocation_registrations(regs)).to match_array(
      [{ 'vocation' => 'customer', 'registrations' => 2 },
       { 'vocation' => 'business', 'registrations' => 1 }]
    )
  end

  it 'Calculates the session flows for a user session' do
    expect(CalculateMetrics.session_flows(visits)).to match_array(
      [{ 'id' => visit_root.session_identifier, 'flow' => [visit_root], 'registered' => false },
       { 'id' => visit_reviews.session_identifier, 'flow' => [visit_reviews], 'registered' => false },
       { 'id' => visit_newsletters.session_identifier, 'flow' => [visit_newsletters], 'registered' => true }]
    )
  end

  it 'Calculates the number of visits per hour' do
    CalculateMetrics.time_visits(visits).each do |time_visits|
      if time_visits['time'] == DateTime.parse('2021-11-27 16:39:22').change({ min: 0, sec: 0 }).to_i
        expect(time_visits['visits']).to eq(3)
      else
        expect(time_visits['visits']).to eq(0)
      end
    end
  end

  it 'Calculates the number of registrations at each hour, for each vocation (and total)' do
    CalculateMetrics.time_registrations(regs).each do |time_registrations|
      if time_registrations['time'] == DateTime.parse('2021-11-27 16:39:22').change({ min: 0, sec: 0 }).to_i
        case time_registrations['vocation']
        when 'total'
          expect(time_registrations['registrations']).to eq(3)
        when 'customer'
          expect(time_registrations['registrations']).to eq(2)
        when 'business'
          expect(time_registrations['registrations']).to eq(1)
        else
          raise 'Unexpected vocation'
        end
      else
        expect(time_registrations['registrations']).to eq(0)
      end
    end
  end

  it 'gets the number of times a feature is share to which social network' do
    10.times do
      FactoryBot.create(:share, feature: 'Feature2', social: 'email')
      FactoryBot.create(:share, feature: 'Feature1', social: 'twitter')
      FactoryBot.create(:share, feature: 'Feature2', social: 'facebook')
    end

    5.times do
      FactoryBot.create(:share, feature: 'Feature1', social: 'email')
      FactoryBot.create(:share, feature: 'Feature2', social: 'twitter')
      FactoryBot.create(:share, feature: 'Feature1', social: 'facebook')
    end

    expect(CalculateMetrics.feature_shares(Share.all)).to match_array(
      [{ 'feature' => 'Feature1', 'social' => 'email', 'count' => 5 },
       { 'feature' => 'Feature1', 'social' => 'twitter', 'count' => 10 },
       { 'feature' => 'Feature1', 'social' => 'facebook', 'count' => 5 },
       { 'feature' => 'Feature2', 'social' => 'email', 'count' => 10 },
       { 'feature' => 'Feature2', 'social' => 'twitter', 'count' => 5 },
       { 'feature' => 'Feature2', 'social' => 'facebook', 'count' => 10 }]
    )
  end

  it 'gets the number of product additions per hour' do
    CalculateMetrics.time_products(products).each do |time_products|
      if time_products['time'] == product1.created_at.change({ min: 0, sec: 0 }).to_i
        expect(time_products['products']).to eq 2
      elsif time_products['time'] == product3.created_at.change({ min: 0, sec: 0 }).to_i
        expect(time_products['products']).to eq 1
      else
        expect(time_products['products']).to eq(0)
      end
    end
  end

  it 'gets the number of products by category' do
    expect(CalculateMetrics.product_categories).to match_array(
      [{ 'category' => 'shirt', 'products' => 2 },
       { 'category' => 'shoes', 'products' => 1 }]
    )
  end

  it 'Returns nil if there are no visits in the system' do
    expect(CalculateMetrics.page_visits(nil)).to eq(nil)
    expect(CalculateMetrics.page_visits([])).to eq(nil)

    expect(CalculateMetrics.time_visits(nil)).to eq(nil)
    expect(CalculateMetrics.time_visits([])).to eq(nil)

    expect(CalculateMetrics.session_flows(nil)).to eq(nil)
    expect(CalculateMetrics.session_flows([])).to eq(nil)
  end

  it 'Returns nil if there are no registrations in the system' do
    expect(CalculateMetrics.vocation_registrations(nil)).to eq(nil)
    expect(CalculateMetrics.vocation_registrations([])).to eq(nil)

    expect(CalculateMetrics.time_registrations(nil)).to eq(nil)
    expect(CalculateMetrics.time_registrations([])).to eq(nil)
  end

  it 'Returns nil if there are no shares in the system' do
    expect(CalculateMetrics.feature_shares(nil)).to eq(nil)
    expect(CalculateMetrics.feature_shares([])).to eq(nil)
  end

  it 'Returns nil if there are no products in the system' do
    expect(CalculateMetrics.time_products(nil)).to eq(nil)
    expect(CalculateMetrics.time_products([])).to eq(nil)
  end
end
