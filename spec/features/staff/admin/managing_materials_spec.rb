# frozen_string_literal: true

require 'rails_helper'

describe 'Managing newsletters' do
  context 'When I am an admin' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    let!(:material) { FactoryBot.create(:material) }

    specify 'I can see the manage materials button in the nav bar and access the page' do
      visit root_path
      within(:css, 'header') { expect(page).to have_content 'Manage Materials' }
      visit materials_path
      expect(page).to have_current_path materials_path
    end

    specify 'I can edit a material\'s information' do
      visit materials_path
      within(:css, '.table') { click_link 'Edit' }
      fill_in 'material[name]', with: 'new material'
      click_button 'Update Material'

      visit materials_path
      within(:css, '.table') { expect(page).to have_content 'new material' }
    end

    specify 'I can destroy a material', js: true do
      visit materials_path
      within(:css, '.table') { expect(page).to have_content material.name }

      accept_confirm do
        within(:css, '.table') { click_link 'Destroy' }
      end

      within(:css, '.table') { expect(page).to_not have_content material.name }
    end
  end

  context 'When I am not an admin' do
    def check_nav_for_materials
      visit root_path
      within(:css, 'header') { expect(page).to_not have_content 'Manage Materials' }
      visit materials_path
      expect(page).to_not have_current_path materials_path
    end

    specify 'I cannot see manage materials in the navbar if I am not logged in or access the page' do
      check_nav_for_materials
    end

    specify 'I cannot see manage materials in the navbar if I am logged in as a customer or access the page' do
      login_as(FactoryBot.create(:customer), scope: :customer)
      check_nav_for_materials
    end

    specify 'I cannot see manage materials in the navbar if I am logged in as a business or access the page' do
      login_as(FactoryBot.create(:business), scope: :business)
      check_nav_for_materials
    end

    specify 'I cannot see manage materials in the navbar if I am logged in as a reporter or access the page' do
      login_as(FactoryBot.create(:reporter), scope: :staff)
      check_nav_for_materials
    end
  end
end
