# frozen_string_literal: true

require 'rails_helper'

describe 'Shares' do
  context 'When I visit the homepage' do
    context 'I can share the carbon footprint viewer' do
      specify 'by email' do
        expect(Share.count).to eq 0
        visit '/'
        within(:css, '#carbon-footprint-feature') {  }
      end

      specify 'to twitter' do
        visit '/'

      end

      specify 'to facebook' do
        visit '/'
      end
    end
  end

  context 'I can share the browser extension feature' do

  end
end
