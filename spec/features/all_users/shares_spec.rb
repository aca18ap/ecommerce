# frozen_string_literal: true

require 'rails_helper'

describe 'Shares' do
  context 'When I visit the homepage' do
    context 'I can share the carbon footprint viewer' do
      specify 'by email', js: true do
        skip 'Feature needs fixing'
        visit '/'
        within(:css, '#carbon-footprint-feature') { find('#email').click }
      end

      specify 'to twitter', js: true do
        skip 'Feature needs fixing'
        visit '/'
        within(:css, '#carbon-footprint-feature') { find('#twitter').click }
      end

      specify 'to facebook', js: true do
        skip 'Feature needs fixing'
        visit '/'
        within(:css, '#carbon-footprint-feature') { find('#facebook').click }
      end
    end
  end

  context 'When I visit the pricing plans page' do

  end
end
