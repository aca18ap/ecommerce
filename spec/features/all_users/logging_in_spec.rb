# frozen_string_literal: true

require 'rails_helper'

describe 'Logging in' do
  let!(:customer) { FactoryBot.create :customer }
  let!(:reporter) { FactoryBot.create :reporter }

  context 'If I enter the correct credentials' do
    specify 'I can log into my account' do
      visit '/users/sign_in'
      fill_in 'user[email]', with: customer.email
      fill_in 'user[password]', with: customer.password
      click_button 'Log in'
      expect(page).to have_current_path('/users/show')
    end
  end

  context 'If I enter incorrect credentials' do
    specify 'I cannot login to my account' do
      visit '/users/sign_in'
      fill_in 'user[email]', with: customer.email
      fill_in 'user[password]', with: 'incorrect_password'
      click_button 'Log in'
      expect(page).not_to have_current_path('/users/show')
    end

    specify '4 times, I will be warned that I have one failed password check remaining' do
      visit '/users/sign_in'
      4.times do
        fill_in 'user[email]', with: customer.email
        fill_in 'user[password]', with: 'incorrect_password'
        click_button 'Log in'
      end

      expect(page).to have_content 'You have one more attempt before your account is locked.'
    end

    specify '5 or more times, my account will be locked' do
      visit '/users/sign_in'
      5.times do
        fill_in 'user[email]', with: customer.email
        fill_in 'user[password]', with: 'incorrect_password'
        click_button 'Log in'
      end

      # Need to reload db entry examine locked status
      customer.reload
      expect(customer.unlock_token).not_to eq(nil)

      expect(page).to have_content 'Your account is locked.'
    end
  end

  context 'Security' do
    specify 'I cannot login via an SQL injection attack', js: true do
      visit '/users/sign_in'
      fill_in 'user[email]', with: customer.email
      fill_in 'user[password]', with: "incorrect_password') OR '1'--"
      click_button 'Log in'
      expect(page).not_to have_current_path('/users/show')
    end
  end
end
