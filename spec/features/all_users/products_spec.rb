# frozen_string_literal: true

require 'rails_helper'

describe 'Products' do
  context 'As a user' do
    let!(:customer) { FactoryBot.create(:customer) }
    let!(:product) { FactoryBot.create(:product) }
    let!(:material_new) { FactoryBot.create(:material, name: 'Material_New') }

    before { login_as(customer, scope: :customer) }
    specify 'I can add a product' do
      visit new_product_path
      fill_in 'product[name]', with: 'AirForceOne'
      fill_in 'product[category]', with: 'Shoes'
      fill_in 'product[mass]', with: '2'
      fill_in 'product[price]', with: '10.1'
      fill_in 'product[url]', with: 'https://nike.com'
      fill_in 'product[manufacturer]', with: 'nike'
      select 'Vietnam', from: 'Manufacturer country'

      # click_on 'Add Material'
      select material_new.name, from: 'Material'
      fill_in 'product[products_material_attributes][0][percentage]', with: '100'
      click_button 'Create Product'
      visit products_path
      expect(page).to have_content 'AirForceOne'
    end

    specify 'I cannot edit a product' do
      visit products_path
      expect(page).to have_content product.name
      expect(page).not_to have_content 'Edit'
    end

    specify 'I can see the "I have purchased this product" checkbox' do
      visit new_product_path
      expect(page).to have_content 'I have purchased this product'
    end
  end

  context 'As a visitor' do
    let!(:product) { FactoryBot.create(:product) }

    specify 'I can view products' do
      visit products_path
      expect(page).to have_content product.name
    end

    specify 'I can view a particular product' do
      visit products_path
      click_link 'Show'
      expect(page).to have_content product.name
    end

    specify 'I can view a breakdown of how the CO2 was calculated' do
      visit products_path
      click_link 'Show'
      click_on 'chevron'
      find(:css, '#co2_right').should be_visible
      expect(page).to have_content 'How the CO2 was calculated'
    end

    specify 'I cannot add new products unless I register' do
      visit new_product_path
      expect(page).to have_content('Access Denied 403')
    end
  end

  context 'As an admin' do
    let!(:product) { FactoryBot.create(:product) }

    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    specify 'I can edit a product name and country' do
      visit products_path
      click_link 'Edit'
      expect(page).to have_content 'Editing product'
      fill_in 'product[name]', with: 'UpdatedTestName'
      select 'Italy', from: 'Manufacturer country'
      click_button 'Update Product'
      expect(page).to have_content 'Product was successfully updated.'
    end

    specify 'I can edit a product\' material', js: true do
      visit '/products'
      click_link 'Edit'
      expect(page).to have_content 'Editing product'
      click_link 'Remove Material'
      fill_in 'product[products_material_attributes][1][percentage]', with: '100'
      click_button 'Update Product'
      expect(page).to have_content 'Product was successfully updated.'
    end

    specify 'I can delete a product', js: true do
      visit products_path
      accept_alert do
        click_link 'Destroy'
      end
      expect(page).not_to have_content product.name
    end

    specify 'I cannot see the "I have purchased this product" checkbox' do
      visit new_product_path
      expect(page).to_not have_content 'I have purchased this product'
    end
  end

  context 'As a business' do
    before { login_as(FactoryBot.create(:business), scope: :business) }

    specify 'I cannot see the "I have purchased this product" checkbox' do
      visit new_product_path
      expect(page).to_not have_content 'I have purchased this product'
    end
  end
end
