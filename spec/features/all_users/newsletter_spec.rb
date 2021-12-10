require 'rails_helper'

describe 'Newsletters' do

  context 'If I provide a valid email address' do
    specify 'I can register my interest as a business' do
      visit '/'
      click_link 'as a business'
      click_link 'Sign up'
      fill_in 'newsletter[email]', with: 'test@example.com'
      click_button 'Register Interest'
      expect(page).to have_content "Vocation: Business"
    end

    specify 'I can register my interest as a free customer' do
      visit '/'
      click_link 'as a customer'
      click_link 'free'
      fill_in 'newsletter[email]', with: 'test@example.com'
      click_button 'Register Interest'
      expect(page).to have_content "Vocation: Customer"
    end

    specify 'I can register my interest as a solo customer' do
      visit '/'
      click_link 'as a customer'
      click_link 'solo'
      fill_in 'newsletter[email]', with: 'test@example.com'
      click_button 'Register Interest'
      expect(page).to have_content "Vocation: Customer"
    end

    specify 'I can register my interest as a family customer' do
      visit '/'
      click_link 'as a customer'
      click_link 'family'
      fill_in 'newsletter[email]', with: 'test@example.com'
      click_button 'Register Interest'
      expect(page).to have_content "Vocation: Customer"
    end
  end

  context 'If I provide an invalid email address' do
    specify 'I am shown an error' do
      visit new_newsletter_path
      fill_in 'newsletter[email]', with: 'example.com'
      click_button 'Register Interest'
      expect(page).to have_content "Please review the problems below"
    end
  end

  context 'If I have already registered interest' do

    let!(:free_customer_newsletter) { FactoryBot.create(:free_customer_newsletter) }

    specify 'I am shown an error' do
      visit new_newsletter_path
      fill_in 'newsletter[email]', with: 'freecustomer@team04.com'
      click_button 'Register Interest'
      expect(page).to have_content "Please review the problems below"
    end
  end

  context 'Security' do
    specify 'I cannot perform an XSS attack' do
      visit new_newsletter_path
      fill_in 'newsletter[email]', with: "<h1>Hello</h1>
                                <script>
                                  $(function() {
                                    window.location.replace('http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html');
                                  });
                                </script>"
      click_button 'Register Interest'
      expect(current_url).not_to eq 'http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html'
      expect(page).to have_content "Please review the problems below"
    end
  end

  specify 'I cannot perform an SQL injection attack' do
    visit new_newsletter_path
    fill_in 'newsletter[email]', with: "'); DROP TABLE Newsletters--"
    click_button 'Register Interest'
    expect(page).to have_content "Please review the problems below"
  end
end
