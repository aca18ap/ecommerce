require 'rails_helper'

describe 'Managing reviews' do
  let!(:review) { FactoryBot.create(:review) }
  let!(:hidden_review) { FactoryBot.create(:hidden_review) }

  specify 'I can view shown reviews on the landing page' do
    visit '/'
    within(:css, '.table') { expect(page).to have_content 'MyText' }
  end

  specify 'I cannot view hidden posts on the landing page' do
    visit '/'
    within(:css, '.table') { expect(page).not_to have_content 'MyHiddenText' }
  end

  context 'If I fill in the required information' do
    specify 'I can submit a review' do
      visit '/'
      click_button 'Leave A Review'
      fill_in 'review[description]', with: 'A review string'
      click_button 'Create Review'
      expect(page).to have_content 'Review was successfully created.'
    end

    specify 'A review that I submit is hidden by default' do
      visit '/'
      click_button 'Leave A Review'
      fill_in 'review[description]', with: 'A review string'
      click_button 'Create Review'
      visit '/'
      within(:css, '.table') { expect(page).not_to have_content 'A review string' }
    end
  end

  context 'If I do not provide any content for the review' do
    specify 'I am showed an error' do
      visit '/'
      click_button 'Leave A Review'
      click_button 'Create Review'
      expect(page).to have_content "Description can't be blan"
    end
  end

  specify 'I can state that a review was useful' do
    visit '/'
    within(:css, '.table') { click_link 'Rate it useful' }
    expect(page).to have_content 'Thank you for your feedback.'
  end

  context 'Security', js: true do
    before { login_as(FactoryBot.create(:admin)) }

    specify 'I cannot perform an SQL injection attack' do
      visit '/'
      click_button 'Leave A Review'
      fill_in 'review[description]', with: "'); DROP TABLE Reviews--"
      click_button 'Create Review'
      expect(page).to have_content "'); DROP TABLE Reviews--"
    end

    specify 'I cannot perform an XSS attack' do
      visit '/'
      click_button 'Leave A Review'
      fill_in 'review[description]', with: "<h1>Hello</h1>
                                <script>
                                  $(function() {
                                    window.location.replace('http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html');
                                  });
                                </script>"
      click_button 'Create Review'
      sleep(2)
      expect(current_url).not_to eq 'http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html'
      expect(page).to have_content '<h1>Hello</h1>'
    end
  end
end
