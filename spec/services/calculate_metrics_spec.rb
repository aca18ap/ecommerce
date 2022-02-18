# frozen_string_literal: true

require 'rails_helper'

describe 'Calculating metrics' do
  let(:visit_root) { FactoryBot.create(:visit_root) }
  let(:visit_reviews) { FactoryBot.create(:visit_reviews) }
  let(:visit_newsletters) { FactoryBot.create(:visit_newsletters_new) }

  let(:free_customer_newsletter) { FactoryBot.create(:free_customer_newsletter) }
  let(:solo_customer_newsletter) { FactoryBot.create(:solo_customer_newsletter) }
  let(:family_customer_newsletter) { FactoryBot.create(:family_customer_newsletter) }
  let(:business_newsletter) { FactoryBot.create(:business_newsletter) }

  let(:calculate_metrics) do
    CalculateMetrics.new(
      [visit_root, visit_reviews, visit_newsletters],
      [free_customer_newsletter, solo_customer_newsletter, family_customer_newsletter, business_newsletter],
      []
    )
  end

  let(:no_data_calculate_metrics) do
    CalculateMetrics.new(nil, nil, nil)
  end

  it 'Calculates visits to each site page' do
    expect(calculate_metrics.page_visits).to eq([{ 'page' => '/', 'visits' => 1 },
                                                 { 'page' => '/reviews', 'visits' => 1 },
                                                 { 'page' => '/newsletters/1', 'visits' => 1 }])
  end

  it 'Calculates the number of registrations by vocation' do
    expect(calculate_metrics.vocation_registrations).to eq([{ 'vocation' => 'Customer', 'registrations' => 3 },
                                                            { 'vocation' => 'Business', 'registrations' => 1 }])
  end

  it 'Calculates the number of customer registrations by tier' do
    expect(calculate_metrics.tier_registrations).to eq([{ 'tier' => 'Free', 'registrations' => 1 },
                                                        { 'tier' => 'Solo', 'registrations' => 1 },
                                                        { 'tier' => 'Family', 'registrations' => 1 }])
  end

  it 'Calculates the session flows for a user session' do
    expect(calculate_metrics.session_flows).to eq([
                                                    { 'id' => 'session_1', 'flow' => [visit_root],
                                                      'registered' => false },
                                                    { 'id' => 'session_2', 'flow' => [visit_reviews],
                                                      'registered' => false },
                                                    { 'id' => 'session_3', 'flow' => [visit_newsletters],
                                                      'registered' => true }
                                                  ])
  end

  it 'Calculates the number of visits per hour' do
    calculate_metrics.time_visits.each do |time_visits|
      if time_visits['time'] == DateTime.parse('2021-11-27 16:39:22').change({ min: 0, sec: 0 }).to_i
        expect(time_visits['visits']).to eq(3)
      else
        expect(time_visits['visits']).to eq(0)
      end
    end
  end

  it 'Calculates the number of registrations at each hour, for each vocation (and total)' do
    calculate_metrics.time_registrations.each do |time_registrations|
      if time_registrations['time'] == DateTime.parse('2021-11-27 16:39:22').change({ min: 0, sec: 0 }).to_i
        case time_registrations['vocation']
        when 'Total'
          expect(time_registrations['registrations']).to eq(4)
        when 'Customer'
          expect(time_registrations['registrations']).to eq(3)
        when 'Business'
          expect(time_registrations['registrations']).to eq(1)
        else
          raise 'Unexpected vocation'
        end
      else
        expect(time_registrations['registrations']).to eq(0)
      end
    end
  end

  it 'gets the number of times a feature shares' do
    skip 'DIDNT HAVE TIME'
  end

  it 'Returns nil if there are no visits in the system' do
    expect(no_data_calculate_metrics.page_visits).to eq(nil)
    expect(no_data_calculate_metrics.time_visits).to eq(nil)
    expect(no_data_calculate_metrics.session_flows).to eq(nil)
  end

  it 'Returns nil if there are no visits in the system' do
    expect(no_data_calculate_metrics.vocation_registrations).to eq(nil)
    expect(no_data_calculate_metrics.tier_registrations).to eq(nil)
    expect(no_data_calculate_metrics.time_registrations).to eq(nil)
  end

end
