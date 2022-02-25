# frozen_string_literal: true

require 'rails_helper'

describe 'Shares' do
  context 'When I visit the homepage' do
    context 'I can share the carbon footprint viewer' do
      specify 'by email', js: true do
        #skip 'Feature needs fixing'
        visit '/'
        within(:css, '#carbon-footprint-feature') { find('#email').click }
      end

      specify 'to twitter', js: true do
        #skip 'Feature needs fixing'
        visit '/'
        within(:css, '#carbon-footprint-feature') { find('#twitter').click }
      end

      specify 'to facebook', js: true do
        #skip 'Feature needs fixing'
        visit '/'
        within(:css, '#carbon-footprint-feature') { find('#facebook').click }
      end
    end
  end

  context 'When I visit the pricing plans page' do
    context 'I can share the unlimited suggestions feature' do
      specify 'to facebook', js: true do
        visit '/pricing_plans'

        within(:css, '#unlimited-suggestions') { find('#expand').click }
        find('#facebook').click
      end 
      specify 'to email', js: true do
        visit '/pricing_plans'

        within(:css, '#unlimited-suggestions') { find('#expand').click }
        find('#email').click
      end      
      specify 'to twitter', js: true do
        visit '/pricing_plans'

        within(:css, '#unlimited-suggestions') { find('#expand').click }
        find('#twitter').click
      end
    end
  end
end
