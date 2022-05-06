# frozen_string_literal: true

require 'rails_helper'

describe 'Product accessibility' do
  feature 'Add customer product', js: true do
    scenario 'is accessible' do
      visit new_product_path
      expect(page).to be_axe_clean
    end
  end
end
