require 'rails_helper'

describe 'Logging in' do
  let!(:customer) { FactoryBot.create :customer }
  let!(:reporter) { FactoryBot.create :reporter }

  context 'If I enter the correct credentials' do
    specify 'I can log into my account' do
      visit '/users/sign_in'
      fill_in 'user[email]', with: 'customer@team04.com'
      fill_in 'user[password]', with: 'Password123'
      click_button 'Log in'
      expect(page).to have_current_path('/users/show')
    end
  end

  context 'If I enter incorrect credentials' do
    specify 'I cannot login to my account' do
      visit '/users/sign_in'
      fill_in 'user[email]', with: 'customer@team04.com'
      fill_in 'user[password]', with: 'incorrect_password'
      click_button 'Log in'
      expect(page).not_to have_current_path('/users/show')
    end
  end

  context 'Security' do
    specify 'I cannot login via an SQL injection attack', js: true do
      visit '/users/sign_in'
      fill_in 'user[email]', with: 'customer@team04.com'
      fill_in 'user[password]', with: "incorrect_password') OR '1'--"
      click_button 'Log in'
      expect(page).not_to have_current_path('/users/show')
    end

    specify 'I cannot change my user role via mass assignment' do
      skip 'COME BACK WHEN YOU WORK OUT HOW TO TEST THIS'
    end
  end
end
