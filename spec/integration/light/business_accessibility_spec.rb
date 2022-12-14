# frozen_string_literal: true

require 'rails_helper'

describe 'Business accessibility' do
  let!(:business) { FactoryBot.create(:business) }
  before { login_as(business, scope: :business) }

  feature 'Business dashboard', js: true do
    scenario 'is accessible' do
      visit dashboard_path
      sleep(0.5) # Wait for graph to load
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
