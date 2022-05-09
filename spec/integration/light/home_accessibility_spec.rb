# frozen_string_literal: true

require 'rails_helper'

describe 'Homepage accessibility' do
  feature 'Home page', js: true do
    scenario 'is accessible' do
      visit '/'
      expect(page).to be_axe_clean
    end
  end
end
