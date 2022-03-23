# frozen_string_literal: true

require 'rails_helper'

describe 'Search Products' do
  context 'As an unregistered user' do
    let!(:product) { FactoryBot.create(:product) }
    # let!(:customer) { FactoryBot.create(:customer) }
    # before { login_as(customer) }
    specify 'I can view products related to an entered search term' do
      visit '/'
      fill_in 'search_term', with: 'TestName'
      click_button
      within(:css, '.table') { expect(page).to have_content 'TestName' }
    end

    specify 'If no products match my search term, I see no results' do
      visit '/'
      fill_in 'search_term', with: 'ProductNotInSystem'
      click_button
      expect(page).to have_content 'No products found'
    end

    specify 'I can sort search results by ascending order' do
      skip 'Not implemented yet'
    end

    specify 'I can sort search results by descending order' do
      skip 'Not implemented yet'
    end

    specify 'I cannot perform an injection attack' do
      skip 'Not implemented yet'
    end

    specify 'I cannot perform an XSS attack' do
      skip 'Not implemented yet'
    end
  end
end


  # context 'As a visitor' do
  #   let!(:product) { FactoryBot.create(:product) }
  #   specify 'I can view products' do
  #     visit '/products'
  #     expect(page).to have_content('TestName')
  #   end

  #   specify 'I cannot add new products unless I register' do
  #     visit '/products/new'
  #     expect(page).to have_content('Access Denied 403')
  #   end
  # end

  # context 'As an admin' do
  #   let!(:product) { FactoryBot.create(:product) }
  #   before { login_as(FactoryBot.create(:admin), scope: :staff) }
  #   specify 'I can edit a product' do
  #     visit '/products'
  #     click_link 'Edit'
  #     expect(page).to have_content 'Editing product'
  #     fill_in 'product[name]', with: 'UpdatedTestName'
  #     select 'Italy', from: 'Manufacturer country' # #factory bot not setting country correctly and makes test fail
  #     click_button 'Update Product'
  #     expect(page).to have_content 'Product was successfully updated.'
  #   end
  #   specify 'I can delete a product', js: true do
  #     visit '/products'
  #     accept_alert do
  #       click_link 'Destroy'
  #     end
  #     expect(page).not_to have_content 'TestName'
  #   end
  # end