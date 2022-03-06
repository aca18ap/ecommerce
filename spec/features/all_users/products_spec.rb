# frozen_string_literal: true

require 'rails_helper'

describe 'Products' do

  context 'As a user' do
    let!(:customer) { FactoryBot.create(:customer) }
    before { login_as(customer) }
    specify 'I can add a product' do
      visit '/products/new'
      fill_in 'product[name]', with: 'AirForceOne'
      fill_in 'product[category]', with: 'Vietnam'
      fill_in 'product[mass]', with: '2'
      fill_in 'product[url]', with: 'nike.com'
      fill_in 'product[manufacturer]', with: 'nike.com'
      select 'Vietnam', :from => 'Manufacturer country'
      click_button 'Create Product'
      visit '/products'
      expect(page).to have_content 'AirForceOne'

    end

    let!(:product){ FactoryBot.create :product}
<<<<<<< HEAD
    specify 'I cannot edit a product' do
      visit '/products'
      expect(page).to have_content 'TestName'
      expect(page).not_to have_content 'Edit'
    end

=======
    specify 'I can edit a product' do
      visit '/products'
      expect(page).to have_content 'TestName'
      click_link 'Edit'
      fill_in 'product[name]', with: 'UpdatedTestName'
      select 'Italy', :from => 'Manufacturer country' ##factory bot not setting country correctly and makes test fail
      click_button 'Update Product'
      expect(page).to have_content 'UpdatedTestName'
      expect(page).to have_content 'Product was successfully updated.'
    end
>>>>>>> Tests for products
  end


  context 'As a visitor' do
    let!(:product) { FactoryBot.create(:product) }
    specify 'I can view products' do
      visit '/products'
      expect(page).to have_content('TestName')
    end

    specify 'I cannot add new products unless I register' do
      visit '/products/new'
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end

  context 'As an admin' do
    let!(:product) { FactoryBot.create(:product)}
    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    specify 'I can edit a product' do
      visit '/products'
      click_link 'Edit'
      expect(page).to have_content 'Editing product'
      fill_in 'product[name]', with: 'UpdatedTestName'
      select 'Italy', :from => 'Manufacturer country' ##factory bot not setting country correctly and makes test fail
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