require 'rails_helper'

describe 'Managing accounts' do
  context 'As an administrator' do
    before { login_as(FactoryBot.create(:admin)) }

    context 'When I enter a valid email' do
      specify 'I can create a new admin', js: true do
        visit '/admin/users'
        click_link 'Invite new user'
        fill_in 'user[email]', with: 'newadmin@team04.com'
        click_button 'Send an invitation'
        expect(page).to have_content 'An invitation email has been sent to newadmin@team04.com.'
        visit '/admin/users'
        within(:css, '#user-1') { expect(page).to have_content 'newadmin@team04.com' }
        page.find('#edit-user-1').click
        select 'admin', from: 'user[role]'
        click_button 'Update User'
        within(:css, '#user-1-role') { expect(page).to have_content 'admin' }
      end

      specify 'I can create a new reporter', js: true do
        visit '/admin/users'
        click_link 'Invite new user'
        fill_in 'user[email]', with: 'newreporter@team04.com'
        click_button 'Send an invitation'
        expect(page).to have_content 'An invitation email has been sent to newreporter@team04.com.'
        visit '/admin/users'
        within(:css, '#user-1') { expect(page).to have_content 'newreporter@team04.com' }
        page.find('#edit-user-1').click
        select 'reporter', from: 'user[role]'
        click_button 'Update User'
        within(:css, '#user-1-role') { expect(page).to have_content 'reporter' }
      end

      specify 'I can create a new customer', js: true do
        visit '/admin/users'
        click_link 'Invite new user'
        fill_in 'user[email]', with: 'newcustomer@team04.com'
        click_button 'Send an invitation'
        expect(page).to have_content 'An invitation email has been sent to newcustomer@team04.com.'
        visit '/admin/users'
        within(:css, '.table') { expect(page).to have_content 'newcustomer@team04.com' }
        within(:css, '#user-1-role') { expect(page).to have_content 'customer' }
      end
    end

    context 'When I enter an invalid email' do
      specify 'I am shown an error' do
        visit '/admin/users'
        click_link 'Invite new user'
        fill_in 'user[email]', with: 'invalid_email'
        click_button 'Send an invitation'
        expect(page).to have_content 'Email is invalid'
      end
    end

    context 'When accounts exist in the system' do
      let!(:customer) { FactoryBot.create :customer }

      specify 'I can delete a user', js: true do
        visit '/admin/users'
        accept_confirm do
          within(:css, '#user-1') { click_link 'Delete' }
        end
        within(:css, '.table') { expect(page).to_not have_content customer.email }
      end

      specify 'I can edit a user\'s role' do
        visit '/admin/users'
        page.find('#edit-user-1').click
        select 'reporter', from: 'user[role]'
        click_button 'Update User'
        within(:css, '#user-1-role') { expect(page).to have_content 'reporter' }
      end

      context 'If I provide a valid email address' do
        specify 'I can edit a user\'s email' do
          visit '/admin/users'
          page.find('#edit-user-1').click
          fill_in 'user[email]', with: 'newemail@email.com'
          click_button 'Update User'
          within(:css, '#user-1') { expect(page).to have_content 'newemail@email.com' }
        end
      end

      context 'If I provide an invalid email' do
        specify 'I will be shown an error when I try to edit a user\'s email' do
          visit '/admin/users'
          page.find('#edit-user-1').click
          fill_in 'user[email]', with: 'invalid_email'
          click_button 'Update User'
          expect(page).to have_content 'Check the user\'s details again!'
        end
      end

      specify 'I cannot add them again' do
        visit '/admin/users'
        click_link 'Invite new user'
        fill_in 'user[email]', with: 'customer@team04.com'
        click_button 'Send an invitation'
        expect(page).to have_content 'Email has already been taken'
      end
    end

    context 'If a users account is locked' do
      let!(:locked) { FactoryBot.create :locked }

      specify 'I can manually unlock it' do
        visit '/admin/users'
        click_link 'Unlock'

        within(:css, '#user-1') { expect(page).not_to have_content 'Unlock' }

        locked.reload
        expect(locked.unlock_token).to eq(nil)
        expect(locked.failed_attempts).to eq(0)
        expect(locked.locked_at).to eq(nil)
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
