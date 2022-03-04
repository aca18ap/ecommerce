# frozen_string_literal: true

require 'rails_helper'

describe 'Managing reviews' do
  context 'As an administrator' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    let!(:review) { FactoryBot.create(:review).decorate }
    let!(:second_review) { FactoryBot.create(:second_review).decorate }
    let!(:hidden_review) { FactoryBot.create(:hidden_review).decorate }

    specify 'The reviews button appears in the nav bar' do
      visit '/'
      within(:css, '.nav') { expect(page).to have_content 'Reviews' }
    end

    specify 'I can see a list of all reviews' do
      visit '/reviews'
      within(:css, '.table') { expect(page).to have_content 'MyText' }
      within(:css, '.table') { expect(page).to have_content 'MyHiddenText' }
    end

    specify 'I can view the usefulness of reviews' do
      visit '/'
      click_link 'Rate it useful'
      visit '/reviews'
      within(:css, '#review-0-rating') { expect(page).to have_content 1 }
    end

    context 'If the rank is 0 when showing a review' do
      specify 'an error is displayed' do
        visit '/reviews'
        within(:css, '.table') { click_button 'Edit' }
        uncheck 'review[hidden]'
        fill_in 'review[rank]', with: 0
        click_button 'Update Review'
        expect(page).to have_content 'Rank should not be 0 for review to be shown on the front page'
      end
    end

    context 'If the rank is not 0 when hiding a review' do
      specify 'an error is displayed' do
        visit '/reviews'
        within(:css, '.table') { click_button 'Edit' }
        check 'review[hidden]'
        fill_in 'review[rank]', with: 1
        click_button 'Update Review'
        expect(page).to have_content 'Rank should be 0 if review is hidden from the front page'
      end
    end

    specify 'I can hide a review' do
      visit '/reviews'
      within(:css, '.table') { click_button 'Edit' }
      check 'review[hidden]'
      fill_in 'review[rank]', with: 0
      click_button 'Update Review'
      visit '/'
      within(:css, '.table') { expect(page).not_to have_content 'MyHiddenText' }
    end

    specify 'I can show a review' do
      visit '/reviews'
      within(:css, '.table') { click_button 'Edit' }
      uncheck 'review[hidden]'
      fill_in 'review[rank]', with: 1
      click_button 'Update Review'
      visit '/'
      within(:css, '.table') { expect(page).to have_content 'MyHiddenText' }
    end

    specify 'I can change the order of reviews' do
      visit '/reviews'
      within(:css, '.table') { click_button 'Edit' }
      fill_in 'review[rank]', with: 2
      click_button 'Update Review'
      visit '/'
      within(:css, '#review-0') { expect(page).to have_content 'MyText' }
      within(:css, '#review-1') { expect(page).to have_content 'MySecondText' }
    end

    specify 'I can delete reviews', js: true do
      visit '/reviews'
      accept_confirm do
        within(:css, '.table') { click_button 'Delete' }
      end
      within(:css, '.table') { expect(page).not_to have_content 'MyHiddenReview' }
    end

    specify 'I can edit review text' do
      visit '/reviews'
      within(:css, '.table') { click_button 'Edit' }
      fill_in 'review[description]', with: 'Edited review'
      fill_in 'review[rank]', with: 0
      click_button 'Update Review'
      expect(page).to have_content 'Edited review'
      visit '/reviews'
      within(:css, '.table') { expect(page).to have_content 'Edited review' }
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