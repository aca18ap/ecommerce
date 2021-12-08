require 'rails_helper'

describe 'Managing newsletters' do
  context 'As an admin' do
    before { login_as(FactoryBot.create(:admin)) }
    let(:newsletter) { FactoryBot.create(:newsletter) }

    specify 'I can view a list of emails provided' do
      visit '/newsletters'
      within(:css, 'table') { expect(page).to have_content 'MyString' }
    end
  end

  context 'Security' do
    specify 'I cannot view a list of emails provided' do
      visit '/newsletters'
      expect(page.status_code).to eq 403
    end

    specify 'I cannot perform an SQL injection attack' do
      skip 'COME BACK AND WORK OUT HOW TO DO THIS'
    end
  end
end
