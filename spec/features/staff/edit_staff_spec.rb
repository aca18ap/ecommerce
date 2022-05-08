# frozen_string_literal: true

require 'rails_helper'

describe 'staff' do
  let!(:staff) { FactoryBot.create(:admin) }
  before { login_as(staff, scope: :staff) }

  before do
    visit staff_edit_path
  end

  context 'When I change my password' do
    it 'requires me to enter my old password' do
      fill_in 'staff[password]', with: 'NewPassword123'
      fill_in 'staff[password_confirmation]', with: 'NewPassword12'
      click_button 'Update'

      expect(page).to have_content 'Current password can\'t be blank'
    end

    it 'requires my old password to be correct' do
      fill_in 'staff[password]', with: 'NewPassword123'
      fill_in 'staff[password_confirmation]', with: 'NewPassword123'
      fill_in 'staff[current_password]', with: 'WrongPassword123'
      click_button 'Update'

      expect(page).to have_content 'Current password is invalid'
    end

    it 'requires my new password to meet the minimum specifications' do
      fill_in 'staff[password]', with: 'a'
      fill_in 'staff[password_confirmation]', with: 'a'
      fill_in 'staff[current_password]', with: staff.password
      click_button 'Update'

      expect(page).to have_content 'Password is too short (minimum is 8 characters)'
      expect(page).to have_content 'Password must contain at least one digit'
      expect(page).to have_content 'Password must contain at least one upper-case letter'
    end

    it 'cannot be the same as the current password' do
      fill_in 'staff[password]', with: 'Password123'
      fill_in 'staff[password_confirmation]', with: 'Password123'
      fill_in 'staff[current_password]', with: staff.password
      click_button 'Update'

      expect(page).to have_content 'Password must be different than the current password.'
    end

    it 'cannot be the same as any of my previous passwords' do
      # Reset password 5 times
      5.times do |idx|
        visit staff_edit_path
        fill_in 'staff[password]', with: "Password#{idx}"
        fill_in 'staff[password_confirmation]', with: "Password#{idx}"
        fill_in 'staff[current_password]', with: staff.password
        click_button 'Update'
      end

      # Reset password to 5th oldest password
      visit staff_edit_path
      fill_in 'staff[password]', with: 'Password0'
      fill_in 'staff[password_confirmation]', with: 'Password0'
      fill_in 'staff[current_password]', with: staff.password
      click_button 'Update'
      expect(page).to have_content 'Password was used previously.'
    end
  end

  context 'If I no longer want to have an account' do
    specify 'I can delete my account', js: true do
      accept_confirm do
        click_link 'Delete account'
      end

      expect(page).to have_current_path '/'
      visit new_staff_session_path
      fill_in 'staff[email]', with: staff.email
      fill_in 'staff[password]', with: staff.password
      click_button 'Log in'
      expect(page).to have_content 'Invalid Email or password.'
    end
  end
end
