# frozen_string_literal: true

require 'rails_helper'

describe 'Managing newsletters' do
  context 'As an admin' do
    before { login_as(FactoryBot.create(:admin)) }
    let!(:newsletter) { FactoryBot.create(:newsletter) }

    specify 'I can see the newsletters button in the nav bar' do
      visit '/newsletters'
      within(:css, 'header') { expect(page).to have_content 'Newsletters' }
    end

    specify 'I can view a list of emails provided' do
      visit '/newsletters'
      expect(page).to have_content newsletter.email
    end
  end

  context 'Security' do
    context 'I cannot view a list of emails provided' do
      specify 'If I am not logged in' do
        visit newsletters_path
        expect(page).to have_content "Access Denied"
      end

      before { login_as(FactoryBot.create(:reporter)) }
      specify 'If I am a reporter' do
        visit newsletters_path
        expect(page).to have_content "Access Denied"
      end

      before { login_as(FactoryBot.create(:customer)) }
      specify 'If I am a customer' do
        visit newsletters_path
        expect(page).to have_content "Access Denied"
      end
    end
  end

  context 'I cannot see the newsletters button in the nav bar' do
    specify 'If I am not logged in' do
      visit '/'
      within(:css, 'header') { expect(page).not_to have_content("Newsletters") }
    end

    before { login_as(FactoryBot.create(:reporter)) }
    specify 'If I am a reporter' do
      visit '/'
      within(:css, 'header') { expect(page).not_to have_content("Newsletters") }
    end

    before { login_as(FactoryBot.create(:user)) }
    specify 'If I am a customer' do
      visit '/'
      within(:css, 'header') { expect(page).not_to have_content("Newsletters") }
    end
  end
end
