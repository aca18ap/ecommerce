require 'rails_helper'

describe 'Voting on FAQs' do
  before {allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '1.2.3.4' }}
  context 'When I see a new FAQ' do
    specify 'I can upvote it' do
      FactoryBot.create :faq
      visit '/faqs'
      expect(page).to have_content 'Rated 0'
      click_button '+'
      expect(page).to have_content 'Rated 1'
    end
    specify 'I can downvote it' do
      FactoryBot.create :faq
      visit '/faqs'
      expect(page).to have_content 'Rated 0'
      click_button '-'
      expect(page).to have_content 'Rated -1'
    end
  end
  context 'When I have upvoted a FAQ' do
    specify 'I can remove my vote' do
      FactoryBot.create(:faq,:with_upvote)
      visit '/faqs'
      expect(page).to have_content 'Rated 1'
      click_button '+'
      expect(page).to have_content 'Rated 0'
    end
    specify 'I can downvote it' do
      FactoryBot.create(:faq,:with_upvote)
      visit '/faqs'
      expect(page).to have_content 'Rated 1'
      click_button '-'
      expect(page).to have_content 'Rated -1'
    end
  end
  context 'When I have downvoted a FAQ' do
    specify 'I can remove my vote' do
      FactoryBot.create(:faq,:with_downvote)
      visit '/faqs'
      expect(page).to have_content 'Rated -1'
      click_button '-'
      expect(page).to have_content 'Rated 0'
    end
    specify 'I can upvote it' do
      FactoryBot.create(:faq,:with_downvote)
      visit '/faqs'
      expect(page).to have_content 'Rated -1'
      click_button '+'
      expect(page).to have_content 'Rated 1'
    end
  end
end