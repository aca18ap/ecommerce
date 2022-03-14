# frozen_string_literal: true

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
  context 'As an administator' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }

    context 'Given that an FAQ already exists and it is not hidden' do
      let!(:faq) { FactoryBot.create(:faq).decorate }

      specify 'I can delete it', js: true do
        visit '/faqs'
        accept_confirm do
          within(:css, '#table') { click_link 'Destroy' }
        end
        within(:css, '#table') { expect(page).to_not have_content faq.question }
      end

      specify 'I can edit it' do
        visit '/faqs'
        within(:css, '#table') { click_link 'Edit' }
        fill_in 'Question', with: 'Updated question'
        click_button 'Submit Question'
        expect(page).to have_content 'Updated question'
      end

      specify 'I can answer it' do
        visit '/faqs'
        within(:css, '#table') { click_link 'Answer' }
        fill_in 'Answer', with: 'Updated answer'
        click_button 'Submit Answer'
        expect(page).to have_content 'Updated answer'
      end

      specify 'I can hide it' do
        visit '/faqs'
        within(:css, '#table') { expect(page).to have_content faq.question }
        within(:css, '#table') { expect(page).to_not have_content 'Hidden' }
        within(:css, '#table') { click_link 'Answer' }
        check 'faq_hidden'
        click_button 'Submit Answer'
        visit '/faqs'
        within(:css, '#table') { expect(page).to have_content 'Hidden' }
      end
    end

    context 'Given that an FAQ already exists and it is hidden' do
      let!(:hidden_faq) { FactoryBot.create(:faq, hidden: true).decorate }

      specify 'I can unhide it' do
        visit '/faqs'
        within(:css, '#table') { expect(page).to have_content hidden_faq.question }
        within(:css, '#table') { expect(page).to have_content 'Hidden' }
        within(:css, '#table') { click_link 'Answer' }
        uncheck 'faq_hidden'
        click_button 'Submit Answer'
        visit '/faqs'
        within(:css, '#table') { expect(page).to_not have_content 'Hidden' }
      end
    end
  end
end