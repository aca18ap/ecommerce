# frozen_string_literal: true

require 'rails_helper'

describe 'Products' do
  context 'As a user' do
    let!(:customer) { FactoryBot.create(:customer) }
    let!(:product) { FactoryBot.create(:product) }
    let!(:material_new) { FactoryBot.create(:material, name: 'Material_New') }

    before { login_as(customer) }
    specify 'I can add a product' do
      visit '/products/new'
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
      # visit '/products'
      expect(page).to have_content 'Product was successfully created'
    end

    specify 'I cannot edit a product' do
      visit '/products'
      expect(page).to have_content 'TestName'
      expect(page).not_to have_content 'Edit'
    end
  end

  context 'As a visitor' do
    let!(:product) { FactoryBot.create(:product) }

    specify 'I can view products' do
      visit '/products'
      expect(page).to have_content('TestName')
    end

    specify 'I cannot add new products unless I register' do
      visit '/products/new'
      expect(page).to have_content('Access Denied 403')
    end
  end

  context 'As an admin' do
    let!(:product) { FactoryBot.create(:product) }

    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    specify 'I can edit a product name and country' do
      visit '/products'
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
      visit '/products'
      accept_alert do
        click_link 'Destroy'
      end
      expect(page).not_to have_content 'TestName'
    end
  end
end
