# frozen_string_literal: true

require 'rails_helper'

# Bug preventing logged in users from leaving reviews on the home page
describe 'Regression test for logged in user reviews' do
  before do
    visit root_path
  end

  def test_review
    click_button 'Leave A Review'
    expect(page).to have_content 'New review'
    expect(page).to_not have_content '403'
  end

  specify 'If I am not logged in I can leave a review' do
    test_review
  end

  specify 'If I logged in as a customer I can leave a review' do
    login_as(FactoryBot.create(:customer), scope: :customer)
    test_review
  end

  specify 'If I logged in as a business I can leave a review' do
    login_as(FactoryBot.create(:business), scope: :business)
    test_review
  end

  specify 'If I logged in as an admin I can leave a review' do
    login_as(FactoryBot.create(:admin), scope: :staff)
    test_review
  end

  specify 'If I logged in as a reporter I can leave a review' do
    login_as(FactoryBot.create(:reporter), scope: :staff)
    test_review
  end
end
