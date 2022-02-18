# frozen_string_literal: true

require 'rails_helper'

# Bug causes account dropdown in navbar not to work on only the site index page. Problem does not occur on any other
# site page for the same dropdown
describe 'Regression test for index dropdown bug' do
  context 'When I click the account dropdown on the FAQs page' do
    specify 'it should display account options', js: true do
      visit '/faqs'
      aria_expanded = page.find('#dropdownUser1')['aria-expanded']
      within(:css, '#dropdownUser1') { expect(aria_expanded).to eq 'false' }

      find('#dropdownUser1').click

      aria_expanded = page.find('#dropdownUser1')['aria-expanded']
      within(:css, '#dropdownUser1') { expect(aria_expanded).to eq 'true' }
    end
  end

  context 'When I click the account dropdown on the homepage' do
    specify 'it should display account options', js: true do
      visit '/'
      aria_expanded = page.find('#dropdownUser1')['aria-expanded']
      within(:css, '#dropdownUser1') { expect(aria_expanded).to eq 'false' }

      find('#dropdownUser1').click

      aria_expanded = page.find('#dropdownUser1')['aria-expanded']
      within(:css, '#dropdownUser1') { expect(aria_expanded).to eq 'true' }
    end
  end
end
