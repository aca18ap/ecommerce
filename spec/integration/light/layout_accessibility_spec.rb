# frozen_string_literal: true

require 'rails_helper'

describe 'Layout accessibility' do
  feature 'Home', js: true do
    scenario 'is accessible' do
      skip 'Until home page is redesigned'
      # visit root_path
      # expect(page).to be_axe_clean
    end
  end

  feature 'Customer login', js: true do
    scenario 'is accessible' do
      visit new_customer_session_path
      expect(page).to be_axe_clean
    end
  end

  feature 'Business login', js: true do
    scenario 'is accessible' do
      visit new_business_session_path
      expect(page).to be_axe_clean
    end
  end

  feature 'Staff login', js: true do
    scenario 'is accessible' do
      visit new_staff_session_path
      expect(page).to be_axe_clean
    end
  end
end
