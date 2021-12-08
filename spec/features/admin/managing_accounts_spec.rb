require 'rails_helper'

describe 'Managing accounts' do
  before { login_as(FactoryBot.create(:admin)) }

  context 'As an administrator' do
    context 'When I enter a valid email' do
      specify 'I can create a new admin', js: true do
        visit '/admin/users'
        click_button 'Invite new user'
        fill_in 'user[email]', with: 'newadmin@team04.com'
        click_button 'Send an invitation'
        click_link 'Accept invitation'
        visit '/admin/users'
        within(:css, '.table') { expect(page).to have_content 'newadmin@team04.com' }
      end

      specify 'I can create a new reporter', js: true do
        visit '/admin/users'
        fill_in 'user[email]', with: 'newreporter@team04.com'
        fill_in 'user[password]', with: 'Password123'
        fill_in 'user[password_confirmation]', with: 'Password123'
        select 'reporter', from: 'user[role]'
        click_button 'Save User'
        within(:css, '.table') { expect(page).to have_content 'newreporter@team04.com' }
      end

      specify 'I can create a new customer', js: true do
        visit '/admin/users'
        fill_in 'user[email]', with: 'newcustomer@team04.com'
        fill_in 'user[password]', with: 'Password123'
        fill_in 'user[password_confirmation]', with: 'Password123'
        select 'customer', from: 'user[role]'
        click_button 'Save User'
        within(:css, '.table') { expect(page).to have_content 'newcustomer@team04.com' }
      end
    end

    context 'When I enter an invalid email' do
      specify 'I am shown an error' do
        visit '/admin/users'

      end
    end

    context 'When accounts exist in the system' do
      let!(:customer) { FactoryBot.create :customer }

      specify 'I can delete a user', js: true do
        visit '/admin/users'
        accept_confirm do
          within(:css, '.table') { click_button 'Delete' }
        end
        within(:css, '.table') { expect(page).to_not have_content 'customer@team04.com' }
      end

      specify 'I can edit a user' do
        skip 'WAITING FOR IMPLEMENTATION'
      end
    end
  end

  context 'security' do
    context 'If I am a reporter' do
      before { login_as(FactoryBot.create(:reporter)) }

      specify 'I cannot access the accounts management system' do
        visit '/admin/users'
        expect(page).not_to have_content 'Admin Dashboard'
        expect(page).to have_current_path('/')
      end
    end

    context 'If I am a customer' do
      before { login_as(FactoryBot.create(:customer)) }

      specify 'I cannot access the accounts management system' do
        visit '/admin/users'
        expect(page).not_to have_content 'Admin Dashboard'
        expect(page).to have_current_path('/')
      end
    end
  end
end
