# frozen_string_literal: true

require 'rails_helper'

describe 'Product Reports' do
  let!(:product) { FactoryBot.create :product }

  context 'As a customer' do
    before { login_as(FactoryBot.create(:customer), scope: :customer) }
    specify 'I can report a product' do
      visit product_path(product)
      click_link 'Report'
      fill_in 'product_report[content]', with: 'ReportContent'
      click_button 'Submit Report'
      expect(page).to have_content 'Thank you for submitting a report'
    end
  end

  context 'As a visitor' do
    specify 'I cannot report a product' do
      visit product_path(product)
      expect(page).to_not have_content('Report')
    end
  end

  context 'As a business' do
    before { login_as(FactoryBot.create(:business), scope: :business) }
    specify 'I can report a product' do
      visit product_path(product)
      click_link 'Report'
      fill_in 'product_report[content]', with: 'ReportContent'
      click_button 'Submit Report'
      expect(page).to have_content 'Thank you for submitting a report'
    end
  end

  context 'As a reporter' do
    before { login_as(FactoryBot.create(:reporter), scope: :staff) }
    specify 'I can report a product' do
      visit product_path(product)
      click_link 'Report'
      fill_in 'product_report[content]', with: 'ReportContent'
      click_button 'Submit Report'
      expect(page).to have_content 'Thank you for submitting a report'
    end
  end

  context 'As an admin' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    specify 'I can report a product' do
      visit product_path(product)
      click_link 'Report'
      fill_in 'product_report[content]', with: 'ReportContent'
      click_button 'Submit Report'
      expect(page).to have_content 'Thank you for submitting a report'
    end
  end
end
