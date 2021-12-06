require 'rails_helper'

describe 'Managing newsletters/registrations of interest' do
  context 'As a potential customer' do
    context 'If I provide a valid email'
    specify 'I can register my interest' do
      skip 'FEATURE NEED FINISHING BEFORE THIS CAN BE FULLY TESTED'
      visit '/newsletters/new'
      fill_in 'newsletter[email]', with: 'valid@email.com'
      expect(page).to have_content 'Thank you for registering interest'
    end
  end

  context 'If I provide an invalid email' do
    specify 'I will be shown an error' do
      skip 'FEATURE NEEDS FINISHING BEFORE THIS CAN BE FULLY TESTED'
      visit '/newsletters/new'
      fill_in 'newsletter[email]', with: 'a'
      expect(page).to have_content 'Invalid email'
    end
  end

  context 'If I have already registered interest' do
    specify 'I will be redirected' do
      skip 'FEATURE NEEDS FINISHING BEFORE THIS CAN BE FULLY TESTED'
      FactoryBot.create :newsletter
      visit '/newsletters/new'
      fill_in 'newsletter[email]', with: 'valid@email.com'
      expect(page).to have_content 'already registered'
    end
  end
end

context 'As a potential business' do
  specify 'I can register interest' do
    skip 'FEATURE NEEDS FINISHING BEFORE THIS CAN BE FULLY TESTED'
  end
end

context 'As an admin' do

  specify 'I can ' do
    skip 'a'
  end
end

