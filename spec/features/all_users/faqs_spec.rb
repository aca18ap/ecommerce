# frozen_string_literal: true

require 'rails_helper'

describe 'Creating FAQs' do
  context 'When I fill in the required information' do
    specify 'I can create a new FAQ entry' do
      visit '/faqs'
      click_link 'Submit a New Question'
      fill_in 'Question', with: 'An important question'
      click_button 'Submit Question'
      expect(page).to have_content 'An important question'
    end
  end

  context 'When I miss out some required information' do
    specify 'I see an error message' do
      visit '/faqs'
      click_link 'Submit a New Question'
      click_button 'Submit Question'
      expect(page).to have_content 'Question can\'t be blank'
    end
  end
end

describe 'Viewing FAQs' do
  context 'When a FAQ is hidden' do
    specify 'I cannot see it' do
      FactoryBot.create(:faq, hidden: true)
      visit '/faqs'
      within(:css, '#table') { expect(page).to_not have_content 'MyQuestion' }
    end
  end
end
