# frozen_string_literal: true

require 'rails_helper'

describe 'User' do
  let!(:customer) { FactoryBot.create(:customer) }
  before { login_as(customer) }

  before do
    visit users_edit_path
  end

  context 'When I change my password' do
    it 'requires me to enter my old password' do
      fill_in 'user[password]', with: 'NewPassword123'
      fill_in 'user[password_confirmation]', with: 'NewPassword12'
      click_button 'Update'

      expect(page).to have_content 'Current password can\'t be blank'
    end

    it 'requires my old password to be correct' do
      fill_in 'user[password]', with: 'NewPassword123'
      fill_in 'user[password_confirmation]', with: 'NewPassword123'
      fill_in 'user[current_password]', with: 'WrongPassword123'
      click_button 'Update'

      expect(page).to have_content 'Current password is invalid'
    end

    it 'requires my new password to meet the minimum specifications' do
      fill_in 'user[password]', with: 'a'
      fill_in 'user[password_confirmation]', with: 'a'
      fill_in 'user[current_password]', with: customer.password
      click_button 'Update'

      expect(page).to have_content 'Password is too short (minimum is 8 characters)'
      expect(page).to have_content 'Password must contain at least one digit'
      expect(page).to have_content 'Password must contain at least one upper-case letter'
    end

    it 'cannot be the same as the current password' do
      fill_in 'user[password]', with: 'Password123'
      fill_in 'user[password_confirmation]', with: 'Password123'
      fill_in 'user[current_password]', with: customer.password
      click_button 'Update'

      expect(page).to have_content 'Password must be different than the current password.'
    end

    it 'cannot be the same as any of my previous passwords' do
      # Reset password 5 times
      5.times do |idx|
        visit users_edit_path
        fill_in 'user[password]', with: "Password#{idx}"
        fill_in 'user[password_confirmation]', with: "Password#{idx}"
        fill_in 'user[current_password]', with: customer.password
        click_button 'Update'
      end

      # Reset password to 5th oldest password
      visit users_edit_path
      fill_in 'user[password]', with: 'Password0'
      fill_in 'user[password_confirmation]', with: 'Password0'
      fill_in 'user[current_password]', with: customer.password
      click_button 'Update'
      expect(page).to have_content 'Password was used previously.'
    end
  end

  context 'If I no longer want to have an account' do
    specify 'I can delete my account', js: true do
      accept_confirm do
        click_link 'Cancel my account'
      end

      expect(page).to have_current_path '/'
      visit '/users/sign_in'
      fill_in 'user[email]', with: customer.email
      fill_in 'user[password]', with: customer.password
      click_button 'Log in'
      expect(page).to have_content 'Invalid Email or password.'
    end
  end
end
