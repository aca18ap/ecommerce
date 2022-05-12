# frozen_string_literal: true

require 'rails_helper'

describe 'Product accessibility' do
  let!(:product) { FactoryBot.create(:product) }

  feature 'Add customer product', js: true do
    scenario 'is accessible' do
      visit new_product_path
      expect(page).to be_axe_clean
    end
  end

  # feature 'View a product', js: true do
  #   skip 'not yet'
  #   scenario 'is accessible' do
  #     visit product_path(product)
  #     expect(page).to be_axe_clean
  #   end
  # end
end
