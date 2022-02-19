# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Shares', type: :request do
  describe 'POST /shares' do
    it 'creates a new share' do
      expect(Share.count).to eq 0

      post shares_path, params: {
        social: 'MySocial',
        feature: 'MyFeature'
      }

      expect(Share.count).to eq 1
      expect(Share.last.social).to eq 'MySocial'
      expect(Share.last.feature).to eq 'MyFeature'
    end
  end
end
