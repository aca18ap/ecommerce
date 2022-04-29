# frozen_string_literal: true

require 'rails_helper'

describe 'Search Products' do
  context 'As an unregistered OR registered user' do
    let!(:product) { FactoryBot.create(:product) }

    specify 'I can view products related to an entered search term' do
      visit '/'
      fill_in 'search_term', with: 'TestName'
      click_button
      within(:css, '.products') { expect(page).to have_content 'TestName' }
    end

    specify 'If no products match my search term, I see no results' do
      visit '/'
      fill_in 'search_term', with: 'ProductNotInSystem'
      click_button
      expect(page).to have_content 'No products found'
    end

    specify 'I can sort search results by ascending order' do
      skip 'Generate required test data with Factorybot'
      # visit '/'
      # fill_in 'search_term', with: 'Test'
      # click_button
      # select 'name', from: 'sort_by'
      # select 'ascending', from: 'order_by'
      # click_button
      # expect('ProductA').to appear_before('ProductB')
    end

    specify 'I can sort search results by descending order' do
      skip 'Generate required test data with Factorybot'
      # visit '/'
      # fill_in 'search_term', with: 'Test'
      # click_button
      # select 'name', from: 'sort_by'
      # select 'descending', from: 'order_by'
      # click_button
      # expect('ProductB').to appear_before('ProductA')
    end

    specify 'I cannot perform an XSS injection attack' do
      visit '/'
      fill_in 'search_term', with: '
        <script>
          $(function() {
            window.location.replace("http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html");
          });
        </script>'
      click_button
      sleep(2)
      expect(current_url).not_to eq 'http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html'
      expect(page).to have_content 'No products found'
    end

    specify 'I cannot perform an SQL injection attack' do
      visit '/'
      fill_in 'search_term', with: "TestName') OR 'SQLTest'--"
      click_button
      expect(page).to have_content "'TestName') OR 'SQLTest'--"
    end
  end
end
