# frozen_string_literal: true

require 'rails_helper'
require 'devise'

describe 'Business logging in in' do
  let!(:business) { FactoryBot.create :business }

  before do
    visit new_business_session_path
  end

  context 'If I enter the correct credentials' do
    specify 'I can log into my account' do
      fill_in 'business[email]', with: business.email
      fill_in 'business[password]', with: business.password
      click_button 'Log in'
      expect(page).to have_current_path businesses_show_path
    end
  end

  context 'If I enter incorrect credentials' do
    specify 'I cannot login to my account' do
      fill_in 'business[email]', with: business.email
      fill_in 'business[password]', with: 'incorrect_password'
      click_button 'Log in'
      expect(page).not_to have_current_path businesses_show_path
    end

    specify '4 times, I will be warned that I have one failed password check remaining' do
      4.times do
        fill_in 'business[email]', with: business.email
        fill_in 'business[password]', with: 'incorrect_password'
        click_button 'Log in'
      end

      expect(page).to have_content 'You have one more attempt before your account is locked.'
    end

    specify '5 or more times, my account will be locked' do
      5.times do
        fill_in 'business[email]', with: business.email
        fill_in 'business[password]', with: 'incorrect_password'
        click_button 'Log in'
      end

      # Need to reload db entry examine locked status
      business.reload
      expect(business.access_locked?).to eq true

      expect(page).to have_content 'Your account is locked.'
    end
  end

  context 'Security' do
    specify 'I cannot login via an SQL injection attack', js: true do
      fill_in 'business[email]', with: business.email
      fill_in 'business[password]', with: "incorrect_password') OR '1'--"
      click_button 'Log in'
      expect(page).not_to have_current_path businesses_show_path
    end
  end

  context 'I cannot log in as a business if I am logged in as' do
    specify 'a staff member' do
      login_as(FactoryBot.create(:admin))

      visit new_business_session_path
      expect(page).to have_current_path staffs_show_path
    end

    specify 'as a customer' do
      login_as(FactoryBot.create(:customer))

      visit new_business_session_path
      expect(page).to have_current_path customers_show_path
    end
  end
end
