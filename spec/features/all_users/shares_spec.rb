# frozen_string_literal: true

require 'rails_helper'

describe 'Shares' do
  context 'When I visit the homepage' do
    context 'I can share the carbon footprint viewer' do
      specify 'by email', js: true do
        #skip 'Feature needs fixing'
        visit '/'
        within(:css, '.carbon-footprint-feature') { find('#email').click }
      end

      specify 'to twitter', js: true do
        #skip 'Feature needs fixing'
        visit '/'
        within(:css, '.carbon-footprint-feature') { find('#twitter').click }
      end

      specify 'to facebook', js: true do
        #skip 'Feature needs fixing'
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
        find('#facebook').click
      end

      specify 'to email', js: true do
        visit '/pricing_plans'
        within(:css, '.unlimited-suggestions') { find('.btn').click }
        find('#email').click
      end

      specify 'to twitter', js: true do
        visit '/pricing_plans'
        within(:css, '.unlimited-suggestions') { find('.btn').click }
        find('#twitter').click
      end
    end

    context 'The post is prefilled with different text for different features' do

      #testing these requires to be logged in to twitter
      specify 'Unlimited suggestions', js: true do
        skip
        visit '/pricing_plans'
        within(:css, '.unlimited-suggestions') { find('.btn').click }
        find('#twitter').click
        expect(page).to have_content 'Get unlimited greener shopping suggestions, only on @ecommerce'
      end

      specify 'One click visit retailer', js: true do
        skip
        visit '/pricing_plans'
        within(:css, '.one-click-access') { find('.btn').click }
        find('#twitter').click
        response.should have_content 'Easy access to green providers when shopping online on @ecommerce'
      end

    end
  end
end
