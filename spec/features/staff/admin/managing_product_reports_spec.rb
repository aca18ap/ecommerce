# frozen_string_literal: true

require 'rails_helper'

describe 'Managing Product Reports' do
  describe 'When I am logged in as an admin' do
    let!(:product_report) { FactoryBot.create(:product_report) }
    before { login_as(FactoryBot.create(:admin), scope: :staff) }

    specify 'I can view existing product reports' do
      visit product_reports_path
      within(:css, '.table') { expect(page).to have_content product_report.content }
    end

    specify 'I can destroy a product report', js: true do
      visit product_reports_path
      within(:css, '.table') { expect(page).to have_content product_report.content }

      accept_confirm do
        within(:css, '.table') { click_link 'Destroy' }
      end

      within(:css, '.table') { expect(page).to_not have_content product_report.content }
    end

    specify 'I can destroy a product with existing reports', js: true do
      visit product_path(product_report.product)
      expect(page).to have_content product_report.product.name

      accept_confirm do
        click_link 'Destroy'
      end

      expect(page).to_not have_content product_report.product.name
    end

    specify 'I can destroy a user with existing reports', js: true do
      visit admin_users_path
      within(:css, '.table') { expect(page).to have_content product_report.customer.username }
      accept_confirm do
        within(:css, "#customer-#{product_report.customer_id}") { click_link 'Delete user' }
      end
      within(:css, '#list-customers-table') { expect(page).to_not have_content product_report.customer.email }
    end
  end

  describe 'Security' do
    context 'I cannot access the manage product reports page' do
      specify 'if I am not logged in' do
        visit product_reports_path
        expect(page).to_not have_current_path product_reports_path
      end

      specify 'if I am a customer' do
        login_as(FactoryBot.create(:customer), scope: :customer)
        visit product_reports_path
        expect(page).to_not have_current_path product_reports_path
      end

      specify 'if I am a business' do
        login_as(FactoryBot.create(:business), scope: :business)
        visit product_reports_path
        expect(page).to_not have_current_path product_reports_path
      end

      specify 'if I am a reporter' do
        login_as(FactoryBot.create(:reporter), scope: :reporter)
        visit product_reports_path
        expect(page).to_not have_current_path product_reports_path
      end
    end
  end
end
