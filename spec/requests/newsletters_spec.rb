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

  context 'Security', js: true do
    specify 'I cannot perform an SQL injection attack' do
      skip 'COME BACK AND FINISH THIS ONE'
      visit '/newsletters/new'
      fill_in 'newsletter[email]', with: "'); DROP TABLE Newsletters--"
      click_button 'Register Interest'
      expect(page).to have_content "'); DROP TABLE Newsletters--"
    end

    specify 'I cannot give myself admin privileges via mass assignment', js: true do
      visit '/'
      click_link 'Edit my details'
      page.execute_script "$('#new_newsletter').append(\"<input value='t' name='user[admin]'>\")"
      sleep 1
      click_button 'Update User'
      expect(user2.reload.admin).to be false
    end

    specify 'I cannot perform an XSS attack' do
      visit '/newsletters/new'
      fill_in 'newsletter[email]', with: "<h1>Hello</h1>
                                <script>
                                  $(function() {
                                    window.location.replace('http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html');
                                  });
                                </script>"
      click_button 'Register Interest'
      sleep(2)
      expect(current_url).not_to eq 'http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html'
    end
  end
end

