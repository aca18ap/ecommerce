# frozen_string_literal: true

require 'rails_helper'
describe 'Shares' do
  context 'When I visit the homepage' do
    context 'I can share the carbon footprint viewer' do
      specify 'by email', js: true do
        visit '/'
        within(:css, '.carbon-footprint-feature') { find('.email-share-button').click }
      end

      specify 'to twitter', js: true do
        visit '/'
        within(:css, '.carbon-footprint-feature') { find('.twitter-share-button').click }
      end

      specify 'to facebook', js: true do
        visit '/'
        within(:css, '.carbon-footprint-feature') { find('.fb-share-button').click }
      end
    end
  end
end
