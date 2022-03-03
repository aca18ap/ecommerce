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
      fill_in 'product[url]', with: 'nike.com'
      fill_in 'product[manufacturer]', with: 'nike.com'
      select 'Vietnam', :from => 'Manufacturer country'
      click_button 'Create Product'
      expect(page).to have_content 'AirForceOne'

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
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end
end