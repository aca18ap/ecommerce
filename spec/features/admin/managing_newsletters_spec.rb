require 'rails_helper'

describe 'Managing newsletters' do
  context 'As an admin' do
    before { login_as(FactoryBot.create(:admin)) }
    let(:newsletter) { FactoryBot.create(:newsletter) }

    specify 'I can see the newsletters button in the nav bar' do
      skip 'IMPLEMENT TEST'
    end

    specify 'I can view a list of emails provided' do
      visit '/newsletters'
      within(:css, 'table') { expect(page).to have_content 'MyString' }
    end
  end

  context 'Security' do
    context 'I cannot view a list of emails provided' do
      specify 'If I am not logged in' do
        skip 'IMPLEMENT TEST'
      end

      specify 'If I am a reporter' do
        skip 'IMPLEMENT TEST'
      end

      specify 'If I am a customer' do
        skip 'IMPLEMENT TEST'
      end
    end
  end

  # NEED TO ADD BUTTON TO NAV BAR FOR ADMINS TO ACCESS LIST OF NEWSLETTERS EASILY
  context 'I cannot see the newsletters button in the nav bar' do
    specify 'If I am not logged in' do
      skip 'IMPLEMENT TEST'
    end

    specify 'If I am a reporter' do
      skip 'IMPLEMENT TEST'
    end

    specify 'If I am a customer' do
      skip 'IMPLEMENT TEST'
    end
  end
end
