# frozen_string_literal: true

require 'rails_helper'
require 'devise'

describe 'Customer logging in in' do
  let!(:customer) { FactoryBot.create :customer }

  before do
    visit new_customer_session_path
  end

  context 'If I enter the correct credentials' do
    specify 'I can log into my account' do
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: customer.password
      click_button 'Log in'
      expect(page).to have_current_path authenticated_customer_root_path
    end
  end

  context 'If I enter incorrect credentials' do
    specify 'I cannot login to my account' do
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: 'incorrect_password'
      click_button 'Log in'
      expect(page).not_to have_current_path authenticated_customer_root_path
    end

    specify '4 times, I will be warned that I have one failed password check remaining' do
      4.times do
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: 'incorrect_password'
        click_button 'Log in'
      end

      expect(page).to have_content 'You have one more attempt before your account is locked.'
    end

    specify '5 or more times, my account will be locked' do
      5.times do
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: 'incorrect_password'
        click_button 'Log in'
      end

      # Need to reload db entry examine locked status
      customer.reload
      expect(customer.access_locked?).to eq true

      expect(page).to have_content 'Your account is locked.'
    end
  end

  context 'Security' do
    specify 'I cannot login via an SQL injection attack', js: true do
      fill_in 'customer[email]', with: customer.email
      fill_in 'customer[password]', with: "incorrect_password') OR '1'--"
      click_button 'Log in'
      expect(page).not_to have_current_path customer_show_path
    end
  end

  context 'I cannot log in as a customer if I am logged in as' do
    specify 'a staff member' do
      login_as(FactoryBot.create(:admin), scope: :staff)

      visit new_customer_session_path
      expect(page).to have_current_path authenticated_admin_root_path
    end

    specify 'as a business' do
      logout(:user)
      login_as(FactoryBot.create(:business), scope: :business)

      visit new_customer_session_path
      expect(page).to have_current_path authenticated_business_root_path
    end
  end
end
