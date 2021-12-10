require 'rails_helper'

 # This spec was generated by rspec-rails when you ran the scaffold generator.
 # It demonstrates how one might use RSpec to test the controller code that
 # was generated by Rails when you ran the scaffold generator.
 #
 # It assumes that the implementation code is generated by the rails scaffold
 # generator. If you are using any extension libraries to generate different
 # controller code, this generated spec may or may not pass.
 #
 # It only uses APIs available in rails and/or rspec-rails. There are a number
 # of tools you can use to make these specs even more expressive, but we're
 # sticking to rails and rspec-rails APIs to keep things simple and stable.


describe 'Managing FAQs' do
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

  context 'Given that an FAQ already exists' do
    before { login_as(FactoryBot.create(:admin)) }

    specify 'I can delete it', js: true do
      FactoryBot.create :faq
      visit '/faqs'
      accept_confirm do
        within(:css, '#table') { click_link 'Destroy' }
      end
      within(:css, '#table') { expect(page).to_not have_content }
    end

    specify 'I can edit it' do
      FactoryBot.create :faq
      visit '/faqs'
      within(:css, '#table') { click_link 'Edit' }
      fill_in 'Question', with: 'Updated question'
      click_button 'Submit Question'
      expect(page).to have_content 'Updated question'
    end

    specify 'I can answer it' do
      FactoryBot.create :faq
      visit '/faqs'
      within(:css, '#table') { click_link 'Answer' }
      fill_in 'Answer', with: 'Updated answer'
      click_button 'Submit Answer'
      expect(page).to have_content 'Updated answer'
    end
  end
end