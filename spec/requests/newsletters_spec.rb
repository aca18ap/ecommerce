require 'rails_helper'

describe 'Managing newsletters/registrations of interest' do
  context 'As a potential customer' do
    context 'If I provide a valid email' do
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
        fill_in 'newsletter[email]', with: 'invalid_email'
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

    context 'Security' do
      specify 'I cannot view a list of emails provided' do
        skip 'FEATURE NEEDS FINISHING BEFORE THIS CAN BE FULLY TESTED'
        visit '/newsletters'
        expect(page.status_code).to eq 403
      end

      specify 'I cannot perform an SQL injection attack' do
        skip 'COME BACK AND WORK OUT HOW TO DO THIS'
      end
    end
  end

  context 'As an admin' do
    before { login_as(FactoryBot.create(:customer)) }

    specify 'I can view a list of emails provided' do
      skip 'FEATURE NEEDS FINISHING BEFORE THIS CAN BE FULLY TESTED'
      visit '/newsletters'
    end
  end
end

