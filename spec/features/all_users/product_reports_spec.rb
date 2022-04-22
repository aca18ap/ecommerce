# frozen_string_literal: true

require 'rails_helper'

describe 'Product Reports' do  
  let!(:product) { FactoryBot.create :product }

  context 'As a customer' do
    let!(:customer) { FactoryBot.create(:customer) }
    before { login_as(customer) }
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
    let!(:business) { FactoryBot.create(:business) }
    before { login_as(business) }
    specify 'I can report a product' do
      visit product_path(product)
      click_link 'Report'
      fill_in 'product_report[content]', with: 'ReportContent'
      click_button 'Submit Report'
      expect(page).to have_content 'Thank you for submitting a report'
    end
  end

  context 'As a reporter' do
    let!(:reporter) { FactoryBot.create(:reporter) }
    before { login_as(reporter) }
    specify 'I can report a product' do
      visit product_path(product)
      click_link 'Report'
      fill_in 'product_report[content]', with: 'ReportContent'
      click_button 'Submit Report'
      expect(page).to have_content 'Thank you for submitting a report'
    end
  end

  context 'As an admin' do
    let!(:admin) { FactoryBot.create(:admin) }
    before { login_as(admin, scope: admin) }
    specify 'I can report a product' do
      visit product_path(product)
      click_link 'Report'
      fill_in 'product_report[content]', with: 'ReportContent'
      click_button 'Submit Report'
      expect(page).to have_content 'Thank you for submitting a report'
    end
  end
end
