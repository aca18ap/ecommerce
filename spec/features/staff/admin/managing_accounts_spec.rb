# frozen_string_literal: true

require 'rails_helper'

describe 'Security' do
  context 'I cannot access the manage accounts page' do
    specify 'if I am not logged in' do
      visit admin_users_path
      expect(page).to_not have_current_path admin_users_path
    end

    specify 'if I am a business' do
      login_as(FactoryBot.create(:business), scope: :business)
      visit admin_users_path
      expect(page).to_not have_current_path admin_users_path
    end

    specify 'if I am a reporter' do
      login_as(FactoryBot.create(:reporter), scope: :reporter)
      visit admin_users_path
      expect(page).to_not have_current_path admin_users_path
    end
  end
end


describe 'Managing customers' do
  let!(:customer) { FactoryBot.create(:customer) }
  let!(:customer2) { FactoryBot.create(:customer, email: 'customer2@team04.com', username: 'taken') }
  let!(:business) { FactoryBot.create(:business) }
  let!(:reporter) { FactoryBot.create(:reporter) }
  before { login_as(FactoryBot.create(:admin), scope: :staff) }

  before do
    visit admin_users_path
  end

  context 'If I provide valid credentials' do
    specify 'I can edit a customer\'s email' do
      puts current_path
      within(:css, "#customer-#{customer.id}") { click_link 'Edit user' }
      fill_in 'customer[email]', with: 'newemail@team04.com'
      click_button 'Update Customer'
      within(:css, '#list-customers-table') { expect(page).to have_content 'newemail@team04.com' }
    end

    specify 'I can edit a customer\'s username' do
      within(:css, "#customer-#{customer.id}") { click_link 'Edit user' }
      fill_in 'customer[username]', with: 'NewUsername'
      click_button 'Update Customer'
      within(:css, '#list-customers-table') { expect(page).to have_content 'NewUsername' }
    end
  end

  context 'If I provide invalid credentials' do
    specify 'I will be shown an error when I try to edit a customer\'s email' do
      within(:css, "#customer-#{customer.id}") { click_link 'Edit user' }
      fill_in 'customer[email]', with: 'invalid_email'
      click_button 'Update Customer'
      expect(page).to have_content 'Email is invalid'
    end

    specify 'I will be shown an error when I try to edit a customer\'s username' do
      within(:css, "#customer-#{customer.id}") { click_link 'Edit user' }
      fill_in 'customer[username]', with: customer2.username
      click_button 'Update Customer'
      expect(page).to have_content 'Username has already been taken'
    end
  end

  context 'I can delete a customer', js: true do
    specify 'from the user management page' do
      accept_confirm do
        within(:css, "#customer-#{customer.id}") { click_link 'Delete user' }
      end
      within(:css, '#list-customers-table') { expect(page).to_not have_content customer.email }
    end

    specify 'from the edit customer page' do
      within(:css, "#customer-#{customer.id}") { click_link 'Edit user' }
      accept_confirm do
        click_link 'Delete Customer'
      end
      within(:css, '#list-customers-table') { expect(page).to_not have_content customer.email }
    end
  end
end
  #   context 'If a user\'s account is locked' do
  #     let!(:locked) { FactoryBot.create :locked }
  #
  #     specify 'I can manually unlock it', js: true do
  #       visit '/admin/users'
  #       accept_confirm do
  #         within(:css, '#user-1') { click_link 'Unlock' }
  #       end
  #       within(:css, '#user-1') { expect(page).not_to have_content 'Unlock' }
  #
  #       locked.reload
  #       expect(locked.unlock_token).to eq(nil)
  #       expect(locked.failed_attempts).to eq(0)
  #       expect(locked.locked_at).to eq(nil)
  #     end
  #   end
  #
  #   context 'If a user\'s account is not locked' do
  #     let!(:customer) { FactoryBot.create :customer }
  #
  #     specify 'I do not see the option to unlock it' do
  #       visit '/admin/users'
  #       within(:css, '#user-1') { expect(page).not_to have_content 'Unlock' }
  #     end
  #   end
  # end
  #
  # context 'security' do
  #   context 'If I am a reporter' do
  #     before { login_as(FactoryBot.create(:reporter)) }
  #
  #     specify 'I cannot access the accounts management system' do
  #       visit '/admin/users'
  #       expect(page).not_to have_content 'Admin Dashboard'
  #       expect(page).to have_current_path('/')
  #     end
  #   end
  #
  #   context 'If I am a customer' do
  #     before { login_as(FactoryBot.create(:customer)) }
  #
  #     specify 'I cannot access the accounts management system' do
  #       visit '/admin/users'
  #       expect(page).not_to have_content 'Admin Dashboard'
  #       expect(page).to have_current_path('/')
  #     end
  #   end
  # end
