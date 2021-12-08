require 'rails_helper'

describe 'Managing newsletters/registrations of interest' do
  context 'As a potential customer' do
    context 'If I provide a valid email' do
      specify 'I can register my interest' do
        visit '/newsletters/new'
        fill_in 'newsletter[email]', with: 'valid@email.com'
        click_button 'Register Interest'
        expect(page).to have_content 'Thank you for registering interest'
      end
    end

    context 'If I provide an invalid email' do
      specify 'I will be shown an error' do
        visit '/newsletters/new'
        fill_in 'newsletter[email]', with: 'invalid_email'
        click_button 'Register Interest'
        expect(page).to have_content 'Invalid email'
      end
    end

    context 'If I have already registered interest' do
      specify 'I will be redirected' do
        FactoryBot.create :newsletter
        visit '/newsletters/new'
        fill_in 'newsletter[email]', with: 'valid@email.com'
        click_button 'Register Interest'
        expect(page).to have_content 'already registered'
      end
    end
end

