require 'rails_helper'

describe 'Managing reviews' do
  # view all reviews
  # remove reviews
  # hide/show reviews
  # edit reviews
  # change rank of reviews
  context 'As an administrator' do
    before { login_as(FactoryBot.create(:admin)) }
    let!(:review) { FactoryBot.create(:review) }
    let!(:hidden_review) { FactoryBot.create(:hidden_review) }

    specify 'The reviews button appears in the nav bar' do
      visit '/'
      within(:css, '.nav') { expect(page).to have_content 'Reviews' }
    end

    specify 'I can see a list of all reviews' do
      visit '/reviews'
      within(:css, '.table') { expect(page).to have_content 'MyText' }
      within(:css, '.table') { expect(page).to have_content 'MyHiddenText' }
    end
    
    context 'If the rank is 0 when showing a review' do
      specify 'an error is displayed' do
        visit '/reviews'
        within(:css, '.table') { click_link 'Edit' }
        check 'review[hidden]'
        fill_in 'review[rank]', with: 0
        click_button 'Update Review'
        expect(page).to have_content 'Rank should not be 0 for review to be shown on the front page'
      end
    end

    specify 'I can hide a review' do
      visit '/reviews'
      within(:css, '.table') { click_link 'Edit' }
      check 'review[hidden]'
      fill_in 'review[rank]', with: 1
      click_button 'Update Review'
      visit '/'
      within(:css, '.table') { expect(page).not_to have_content 'MyText' }
    end

    specify 'I can show a review' do
      visit '/reviews'
      within(:css, '.table') { click_link 'Edit' }
      uncheck 'review[hidden]'
      click_button 'Update Review'
      visit '/'
      within(:css, '.table') { expect(page).to have_content 'MyText' }
    end

    specify 'I can change the order of reviews' do
      visit '/reviews'
      within(:css, '.table') { click_link 'Edit' }


      visit '/'
      within(:css, '.table') { expect(page).to have_content 'MyText' }
    end
  end

  context 'Security' do
    context 'If I am not logged in' do
      specify 'I cannot access the reviews management system' do
        visit '/reviews'
        within(:css, '.nav') { expect(page).not_to have_content 'Reviews' }
        expect(page).not_to have_content 'Listing Reviews'
        expect(page).not_to have_current_path('/reviews')
      end
    end

    context 'If I am a reporter' do
      before { login_as(FactoryBot.create(:reporter)) }

      specify 'I cannot access the reviews management system' do
        visit '/reviews'
        within(:css, '.nav') { expect(page).not_to have_content 'Reviews' }
        expect(page).not_to have_content 'Listing Reviews'
        expect(page).to have_content('Access Denied')
      end
    end

    context 'If I am a customer' do
      before { login_as(FactoryBot.create(:customer)) }

      specify 'I cannot access the reviews management system' do
        visit '/reviews'
        within(:css, '.nav') { expect(page).not_to have_content 'Reviews' }
        expect(page).not_to have_content 'Listing Reviews'
        expect(page).to have_content('Access Denied')
      end
    end
  end
end