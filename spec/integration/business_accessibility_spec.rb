# frozen_string_literal: true

require 'rails_helper'

describe 'Business accessibility' do
  let!(:business) { FactoryBot.create(:business) }
  login_as(business, scope: :business)

  feature 'Sign up as business', js: true do
    scenario 'is accessible' do
      visit new_business_registration_path
      expect(page).to be_axe_clean
    end
  end

  feature 'Add business product', js: true do
    scenario 'is accessible' do
      visit new_product_path
      expect(page).to be_axe_clean
    end
  end

  feature 'Business dashboard', js: true do
    scenario 'is accessible' do
      visit business_path
      expect(page).to be_axe_clean
    end
  end

  feature 'Edit business', js: true do
    scenario 'is accessible' do
      visit edit_business_registration_path
      expect(page).to be_axe_clean
    end
  end
end
