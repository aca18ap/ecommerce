# frozen_string_literal: true

require 'rails_helper'
require 'devise'

describe 'staff logging in in' do
  let!(:staff) { FactoryBot.create(:admin) }

  before do
    visit new_staff_session_path
  end

  context 'If I enter the correct credentials' do
    specify 'I can log into my account' do
      fill_in 'staff[email]', with: staff.email
      fill_in 'staff[password]', with: staff.password
      click_button 'Log in'
      expect(page).to have_current_path authenticated_admin_root_path
    end
  end

  context 'If I enter incorrect credentials' do
    specify 'I cannot login to my account' do
      fill_in 'staff[email]', with: staff.email
      fill_in 'staff[password]', with: 'incorrect_password'
      click_button 'Log in'
      expect(page).not_to have_current_path authenticated_admin_root_path
    end

    specify '4 times, I will be warned that I have one failed password check remaining' do
      4.times do
        fill_in 'staff[email]', with: staff.email
        fill_in 'staff[password]', with: 'incorrect_password'
        click_button 'Log in'
      end

      expect(page).to have_content 'You have one more attempt before your account is locked.'
    end

    specify '5 or more times, my account will be locked' do
      5.times do
        fill_in 'staff[email]', with: staff.email
        fill_in 'staff[password]', with: 'incorrect_password'
        click_button 'Log in'
      end

      # Need to reload db entry examine locked status
      staff.reload
      expect(staff.access_locked?).to eq true

      expect(page).to have_content 'Your account is locked.'
    end
  end

  context 'Security' do
    specify 'I cannot login via an SQL injection attack', js: true do
      fill_in 'staff[email]', with: staff.email
      fill_in 'staff[password]', with: "incorrect_password') OR '1'--"
      click_button 'Log in'
      expect(page).not_to have_current_path metrics_path
    end
  end

  context 'I cannot log in as a staff if I am logged in as' do
    specify 'a customer' do
      login_as(FactoryBot.create(:customer))

      visit new_staff_session_path
      expect(page).to have_current_path authenticated_customer_root_path
    end

    specify 'as a business' do
      login_as(FactoryBot.create(:business))

      visit new_staff_session_path
      expect(page).to have_current_path authenticated_business_root_path
    end
  end
end
