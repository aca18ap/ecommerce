# frozen_string_literal: true

require 'rails_helper'

describe 'Managing Products' do
  describe 'When I am logged in as an admin' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    let!(:product) { FactoryBot.create(:product) }

    specify 'I can see edit and destroy for products in the list' do
      visit products_path
      within(:css, '.table') { expect(page).to have_content 'Edit' }
      within(:css, '.table') { expect(page).to have_content 'Destroy' }
    end
  end

  describe 'When I am not logged in as an admin' do
    def check_table_for_links
      visit products_path
      within(:css, '.table') { expect(page).to_not have_content 'Edit' }
      within(:css, '.table') { expect(page).to_not have_content 'Destroy' }
    end

    specify 'can see edit and destroy for products in the list if I am not logged in' do
      check_table_for_links
    end

    specify 'can see edit and destroy for products in the list if I am logged in as a customer' do
      login_as(FactoryBot.create(:customer), scope: :customer)
      check_table_for_links
    end

    specify 'can see edit and destroy for products in the list if I am logged in as a business' do
      login_as(FactoryBot.create(:business), scope: :business)
      check_table_for_links
    end

    specify 'can see edit and destroy for products in the list if I am logged in as a reporter' do
      login_as(FactoryBot.create(:reporter), scope: :reporter)
      check_table_for_links
    end
  end
end
