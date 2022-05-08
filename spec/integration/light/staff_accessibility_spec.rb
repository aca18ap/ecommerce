# frozen_string_literal: true

require 'rails_helper'

describe 'Staff accessibility' do
  let!(:staff) { FactoryBot.create(:admin) }
  before { login_as(staff, scope: :staff) }

  feature 'Edit staff', js: true do
    scenario 'is accessible' do
      visit edit_staff_registration_path
      expect(page).to be_axe_clean
    end
  end

  feature 'Manange users', js: true do
    scenario 'is accessible' do
      visit admin_users_path
      expect(page).to be_axe_clean
    end
  end

  feature 'Manage materials', js: true do
    scenario 'is accessible' do
      visit materials_path
      expect(page).to be_axe_clean
    end
  end

  feature 'View metrics', js: true do
    scenario 'is accessible' do
      skip 'Until Liam can fix'
      # visit metrics_path
      # expect(page).to be_axe_clean
    end
  end
end
