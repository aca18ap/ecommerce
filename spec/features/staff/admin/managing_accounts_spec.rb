# frozen_string_literal: true

require 'rails_helper'

describe 'Security' do
  context 'I cannot access the manage accounts page' do
    specify 'if I am not logged in' do
      visit admin_users_path
      expect(page).to_not have_current_path admin_users_path
    end

    specify 'if I am a customer' do
      login_as(FactoryBot.create(:customer), scope: :customer)
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
  let!(:suspendedCustomer) { FactoryBot.create(:customer, email: 'customer3@team04.com', username: 'suspended', suspended: true) }
  before { login_as(FactoryBot.create(:admin), scope: :staff) }

  before do
    visit admin_users_path
  end

  context 'If I provide valid credentials' do
    specify 'I can edit a customer\'s email' do
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

  context 'If a customer\'s account is locked' do
    before { customer.lock_access! }
    specify 'I can manually unlock it', js: true do
      visit admin_users_path

      expect(customer.access_locked?).to eq true
      within(:css, "#customer-#{customer.id}") { expect(page).to have_content 'Unlock' }

      accept_confirm do
        within(:css, "#customer-#{customer.id}") { click_link 'Unlock' }
      end

      within(:css, "#customer-#{customer.id}") { expect(page).to_not have_content 'Unlock' }
      expect(customer.reload.access_locked?).to eq false
    end
  end

  context 'If a customer\'s account is not locked' do
    specify 'I cannot unlock it' do
      expect(customer.access_locked?).to_not eq true
      within(:css, "#customer-#{customer.id}") { expect(page).to_not have_content 'Unlock' }
    end
  end

  context 'If a customer\'s account is not suspended' do
    specify 'I can suspend it', js: true do
      expect(customer.suspended?).to_not eq true
      within(:css, "#customer-#{customer.id}") { click_link 'Edit user' }
      check("suspended")
      click_button 'Update Customer'
      expect(customer.reload.suspended?).to eq true
    end
  end

  context 'If a customer\'s account is suspended' do
    specify 'I can lift its suspension' do
      expect(suspendedCustomer.suspended?).to eq true
      within(:css, "#customer-#{suspendedCustomer.id}") { click_link 'Edit user' }
      check("suspended")
      click_button 'Update Customer'
      expect(suspendedCustomer.reload.suspended?).to_not eq true
    end
  end
end

describe 'Managing businesses' do
  let!(:business) { FactoryBot.create(:business) }
  before { login_as(FactoryBot.create(:admin), scope: :staff) }

  before do
    visit admin_users_path
    find('#open-businesses-tab').click
  end

  context 'If I provide valid credentials' do
    specify 'I can edit a business\'s email' do
      within(:css, "#business-#{business.id}") { click_link 'Edit user' }
      fill_in 'business[email]', with: 'newemail@team04.com'
      click_button 'Update Business'
      within(:css, '#list-businesses-table') { expect(page).to have_content 'newemail@team04.com' }
    end

    specify 'I can edit a business\'s name' do
      within(:css, "#business-#{business.id}") { click_link 'Edit user' }
      fill_in 'business[name]', with: 'NewName'
      click_button 'Update Business'
      within(:css, '#list-businesses-table') { expect(page).to have_content 'NewName' }
    end

    specify 'I can edit a business\'s description' do
      within(:css, "#business-#{business.id}") { click_link 'Edit user' }
      fill_in 'business[description]', with: 'NewDescription'
      click_button 'Update Business'

      expect(business.reload.description).to eq 'NewDescription'
    end
  end

  context 'If I provide invalid credentials' do
    specify 'I will be shown an error when I try to edit a business\'s email' do
      within(:css, "#business-#{business.id}") { click_link 'Edit user' }
      fill_in 'business[email]', with: 'invalid_email'
      click_button 'Update Business'
      expect(page).to have_content 'Email is invalid'
    end
  end

  context 'I can delete a business', js: true do
    specify 'from the user management page' do
      accept_confirm do
        within(:css, "#business-#{business.id}") { click_link 'Delete user' }
      end
      find('#open-businesses-tab').click
      within(:css, '#list-businesses-table') { expect(page).to_not have_content business.email }
    end

    specify 'from the edit business page' do
      within(:css, "#business-#{business.id}") { click_link 'Edit user' }
      accept_confirm do
        click_link 'Delete Business'
      end
      find('#open-businesses-tab').click
      within(:css, '#list-businesses-table') { expect(page).to_not have_content business.email }
    end
  end

  context 'If a business\'s account is locked' do
    before { business.lock_access! }
    specify 'I can manually unlock it', js: true do
      visit admin_users_path
      find('#open-businesses-tab').click

      expect(business.access_locked?).to eq true
      within(:css, "#business-#{business.id}") { expect(page).to have_content 'Unlock' }

      accept_confirm do
        within(:css, "#business-#{business.id}") { click_link 'Unlock' }
      end

      find('#open-businesses-tab').click
      within(:css, "#business-#{business.id}") { expect(page).to_not have_content 'Unlock' }
      expect(business.reload.access_locked?).to eq false
    end
  end

  context 'If a business\'s account is not locked' do
    specify 'I cannot unlock it' do
      expect(business.access_locked?).to_not eq true
      within(:css, "#business-#{business.id}") { expect(page).to_not have_content 'Unlock' }
    end
  end

  specify 'I can invite a new business' do
    find('#invite-business-button').click
    fill_in 'business[email]', with: 'newbusiness@team04.com'
    fill_in 'business[name]', with: 'NewName'
    click_link_or_button 'Invite Business'

    new_business = Business.find_by_email('newbusiness@team04.com')
    within(:css, "#business-#{new_business.id}") { expect(page).to have_content 'newbusiness@team04.com' }
  end
end

describe 'Managing staff' do
  let!(:reporter) { FactoryBot.create(:reporter) }
  let!(:admin) { FactoryBot.create(:admin) }
  before { login_as(admin, scope: :staff) }

  before do
    visit admin_users_path
    find('#open-staff-tab').click
  end

  context 'If I provide valid credentials' do
    specify 'I can edit a staff member\'s email' do
      within(:css, "#staff-#{reporter.id}") { click_link 'Edit user' }
      fill_in 'staff[email]', with: 'newemail@team04.com'
      click_button 'Update Staff'
      within(:css, '#list-staff-table') { expect(page).to have_content 'newemail@team04.com' }
    end

    specify 'I can change a staff member\'s role' do
      within(:css, "#staff-#{reporter.id}") { click_link 'Edit user' }
      select 'Admin', from: 'staff[role]'
      click_button 'Update Staff'
      within(:css, "#staff-#{reporter.id}") { expect(page).to have_content 'admin' }
    end
  end

  context 'If I provide invalid credentials' do
    specify 'I will be shown an error when I try to edit a business\'s email' do
      within(:css, "#staff-#{reporter.id}") { click_link 'Edit user' }
      fill_in 'staff[email]', with: 'invalid_email'
      click_button 'Update Staff'
      expect(page).to have_content 'Email is invalid'
    end
  end

  specify 'I cannot edit or delete my own details from this page' do
    within(:css, "#staff-#{admin.id}") { expect(page).to_not have_content 'Edit user' }
    within(:css, "#staff-#{admin.id}") { expect(page).to_not have_content 'Delete user' }
  end

  context 'I can delete a staff member', js: true do
    specify 'from the user management page' do
      accept_confirm do
        within(:css, "#staff-#{reporter.id}") { click_link 'Delete user' }
      end
      find('#open-staff-tab').click
      within(:css, '#list-staff-table') { expect(page).to_not have_content reporter.email }
    end

    specify 'from the edit staff page' do
      within(:css, "#staff-#{reporter.id}") { click_link 'Edit user' }
      accept_confirm do
        click_link 'Delete Staff'
      end
      find('#open-staff-tab').click
      within(:css, '#list-staff-table') { expect(page).to_not have_content reporter.email }
    end
  end

  context 'If a staff member\'s account is locked' do
    before { reporter.lock_access! }
    specify 'I can manually unlock it', js: true do
      visit admin_users_path
      find('#open-staff-tab').click

      expect(reporter.access_locked?).to eq true
      within(:css, "#staff-#{reporter.id}") { expect(page).to have_content 'Unlock' }

      accept_confirm do
        within(:css, "#staff-#{reporter.id}") { click_link 'Unlock' }
      end

      find('#open-staff-tab').click
      within(:css, "#staff-#{reporter.id}") { expect(page).to_not have_content 'Unlock' }
      expect(reporter.reload.access_locked?).to eq false
    end
  end

  context 'If a staff member\'s account is not locked' do
    specify 'I cannot unlock it' do
      expect(reporter.access_locked?).to_not eq true
      within(:css, "#staff-#{reporter.id}") { expect(page).to_not have_content 'Unlock' }
    end
  end

  specify 'I can invite a new staff member as admin' do
    find('#invite-staff-button').click
    fill_in 'staff[email]', with: 'newadmin@team04.com'
    select 'Admin', from: 'staff[role]'
    click_link_or_button 'Invite Staff'

    new_admin = Staff.find_by_email('newadmin@team04.com')
    within(:css, "#staff-#{new_admin.id}") { expect(page).to have_content 'admin' }
  end

  specify 'I can invite a new staff member as reporter' do
    find('#invite-staff-button').click
    fill_in 'staff[email]', with: 'newreporter@team04.com'
    select 'Reporter', from: 'staff[role]'
    click_link_or_button 'Invite Staff'

    new_reporter = Staff.find_by_email('newreporter@team04.com')
    within(:css, "#staff-#{new_reporter.id}") { expect(page).to have_content 'reporter' }
  end
end
