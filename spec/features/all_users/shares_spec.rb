# frozen_string_literal: true

require 'rails_helper'
describe 'Shares' do
  context 'When I visit the homepage' do
    context 'I can share the carbon footprint viewer' do
      specify 'by email', js: true do
        visit '/'
        within(:css, '.carbon-footprint-feature') { find('#email').click }
      end

      specify 'to twitter', js: true do
        visit '/'
        within(:css, '.carbon-footprint-feature') { find('#twitter').click }
      end

      specify 'to facebook', js: true do
        visit '/'
        within(:css, '.carbon-footprint-feature') { find('#facebook').click }
      end
    end
  end

  context 'When I visit the pricing plans page' do
    context 'I can share the unlimited suggestions feature' do
      specify 'to facebook', js: true do
        visit '/pricing_plans'
        within(:css, '.unlimited-suggestions') { find('.btn').click }
        expect(page).to have_css('#facebook')
      end

      specify 'to email', js: true do
        visit '/pricing_plans'
        within(:css, '.unlimited-suggestions') { find('.btn').click }
        expect(page).to have_css('#email')
      end

      specify 'to twitter', js: true do
        visit '/pricing_plans'
        within(:css, '.unlimited-suggestions') { find('.btn').click }
        expect(page).to have_css('#twitter')
      end
    end

    context 'The post is prefilled with different text for different features' do
      specify 'Unlimited suggestions', js: true do
        skip 'need fixing'
        visit '/pricing_plans'
        within(:css, '.unlimited-suggestions') { find('.btn').click }
        w = window_opened_by do
          find('#twitter').click
        end
        within_window w do
          expect(page.current_url).to eq('https://twitter.com/intent/tweet?text=Get%20unlimited%20greener%20shopping%20suggestions%2C%20only%20on%20%40ecommerce')
        end
      end

      specify 'One click visit retailer', js: true do
        skip 'need fixing'
        visit '/pricing_plans'
        within(:css, '.one-click-access') { find('.btn').click }
        find('#twitter').click
        expect(current_url).to eq('https://twitter.com/intent/tweet?text=Easy%20access%20to%20green%20providers%20when%20shopping%20online%20on%20%40ecommerce')
      end

      specify 'View purchase history', js: true do
        skip 'need fixing'

        visit '/pricing_plans'

        within(:css, '.view-purchase-history') { find('.btn').click }
        find('#twitter').click
        expect(current_url).to eq('https://twitter.com/intent/tweet?text=Quick%20access%20to%20your%20carbon%20footprint%2C%20save%20the%20planet%20click%20by%20click%20on%20%40ecommerce')
      end
    end
  end
end
