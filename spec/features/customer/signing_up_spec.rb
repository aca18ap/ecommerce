
# frozen_string_literal: true

require 'rails_helper'

describe 'customer signs up' do
  let!(:customer) { FactoryBot.create :customer }

  before do
    visit new_customer_registration_path
  end

  context 'With valid credentials' do
    specify 'I can create a new customer account' do
      fill_in 'customer[email]', with: 'new_customer@team04.com'
      fill_in 'customer[password]', with: 'Password123'
      fill_in 'customer[password_confirmation]', with: 'Password123'
      click_button 'Sign up'

      expect(page).to have_current_path customers_show_path
    end
  end

  context 'If email already registered' do
    specify 'I cannot create an account using that email' do
      fill_in 'customer_email', with: customer.email
      fill_in 'customer_password', with: customer.password
      fill_in 'customer[password_confirmation]', with: customer.password
      click_button 'Sign up'

      expect(page).to have_text 'Email has already been taken'
    end
  end

  context 'If password invalid' do
    specify 'I cannot create an account using that password' do
      fill_in 'customer_email', with: 'new_customer@team04.com'
      fill_in 'customer_password', with: 'password'
      fill_in 'customer[password_confirmation]', with: 'password'
      click_button 'Sign up'

      expect(page).to have_text 'Password must contain at least one digit and Password must contain at least one upper-case letter'
    end
  end

  context 'If I enter two different valid passwords' do
    specify 'I cannot create an account' do
      fill_in 'customer_email', with: 'new_customer@team04.com'
      fill_in 'customer_password', with: 'Passw0rd'
      fill_in 'customer[password_confirmation]', with: 'Passw0rd1'
      click_button 'Sign up'

      expect(page).to have_text "Password confirmation doesn't match Password"
    end
  end
end
