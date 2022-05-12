# frozen_string_literal: true

require 'rails_helper'

describe 'Reviews' do
  context 'Viewing reviews' do
    let!(:review) { FactoryBot.create(:review).decorate }
    let!(:hidden_review) { FactoryBot.create(:hidden_review).decorate }
    let!(:long_review) { FactoryBot.create(:review, id: 2, description: 'a' * 121).decorate }

    before do
      visit root_path
    end

    specify 'I can view shown reviews on the landing page' do
      within(:css, '.testimonial-slider') { expect(page).to have_content 'MyText' }
    end

    context 'If a review has more than 120 characters in the description' do
      specify 'The review description is truncated' do
        within(:css, '.testimonial-slider') { expect(page).to have_content "#{'a' * 117}..." }
      end
    end

    specify 'I cannot view hidden posts on the landing page' do
      within(:css, '.testimonial-slider') { expect(page).not_to have_content 'MyHiddenText' }
    end

    specify 'I can state that a review was useful' do
      within(:css, '.testimonial-slider') { click_link 'Rate this' }
      expect(page).to have_content 'Thank you for your feedback.'
    end
  end

  context 'Creating reviews' do
    before do
      visit root_path
    end

    context 'If I fill in the required information' do
      specify 'I can submit a review' do
        click_link 'Leave A Review'
        fill_in 'review[description]', with: 'A review string'
        click_button 'Create Review'
        expect(page).to have_content 'Thank you for leaving feedback!'
      end

      specify 'A review that I submit is hidden by default' do
        click_link 'Leave A Review'
        fill_in 'review[description]', with: 'A review string'
        click_button 'Create Review'
        visit root_path
        within(:css, '.testimonial-slider') { expect(page).not_to have_content 'A review string' }
      end
    end

    context 'If I do not provide any content for the review' do
      specify 'I am showed an error' do
        click_link 'Leave A Review'
        click_button 'Create Review'
        expect(page).to have_content "Description can't be blank"
      end
    end
  end

  context 'Security', js: true do
    before do
      visit root_path
    end

    specify 'I cannot perform an SQL injection attack' do
      click_link 'Leave A Review'
      fill_in 'review[description]', with: "'); DROP TABLE Reviews--"
      click_button 'Create Review'

      login_as(FactoryBot.create(:admin), scope: :staff)
      visit reviews_path
      expect(page).to have_content "'); DROP TABLE Reviews--"
    end

    specify 'I cannot perform an XSS attack' do
      click_link 'Leave A Review'
      fill_in 'review[description]', with: "<h1>Hello</h1>
                                <script>
                                  $(function() {
                                    window.location.replace('http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html');
                                  });
                                </script>"
      click_button 'Create Review'

      login_as(FactoryBot.create(:admin), scope: :staff)
      visit reviews_path
      sleep(2)
      expect(current_url).not_to eq 'http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html'
      expect(page).to have_content '<h1>Hello</h1>'
    end
  end
end
