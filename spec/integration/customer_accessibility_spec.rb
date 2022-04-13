# frozen_string_literal: true

require 'rails_helper'

describe 'Customer accessibility' do
  let!(:customer) { FactoryBot.create(:customer) }
  before { login_as(customer, scope: :customer) }

  feature 'Sign up as customer', js: true do
    scenario 'is accessible' do
      visit new_customer_registration_path
      expect(page).to be_axe_clean
    end
  end

  feature 'Customer dashboard', js: true do
    scenario 'is accessible' do
      login_as(customer, scope: :customer)
      visit customer_show_path
      expect(page).to be_axe_clean
    end
  end

  feature 'Edit customer', js: true do
    scenario 'is accessible' do
      login_as(customer, scope: :customer)
      visit edit_customer_registration_path
      expect(page).to be_axe_clean
    end
  end
end
