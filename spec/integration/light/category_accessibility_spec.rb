# frozen_string_literal: true

require 'rails_helper'

describe 'Category accessibility' do
  let!(:category) { FactoryBot.create(:category) }
  let!(:product) { FactoryBot.create(:product, category_id: category.id) }

  feature 'View a category', js: true do
    scenario 'is accessible' do
      visit categories_path(category)
      expect(page).to be_axe_clean
    end
  end
end
