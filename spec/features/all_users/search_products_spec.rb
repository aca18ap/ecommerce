# frozen_string_literal: true

require 'rails_helper'

describe 'Search Products' do
  context 'As an unregistered OR registered user' do
    let!(:product) { FactoryBot.create(:product) }

    specify 'I can view products related to an entered search term' do
      visit '/'
      fill_in 'q_name_or_description_or_manufacturer_or_category_name_cont', with: 'TestName'
      click_button
      within(:css, '.products') { expect(page).to have_content 'TestName' }
    end

    specify 'If no products match my search term, I see no results' do
      visit '/'
      fill_in 'q_name_or_description_or_manufacturer_or_category_name_cont', with: 'ProductNotInSystem'
      click_button
      expect(page).to have_content 'No products found'
    end

    specify 'I can sort search results by ascending order' do
      (1..9).each do |i|
        FactoryBot.create(:product, name: "Product #{i}", url: "https://www.test#{i}")
      end
      visit products_path
      fill_in 'q_name_or_description_or_manufacturer_or_category_name_cont', with: 'Product'
      click_button
      find('a', text: 'Name').click
      within(:css, '.products') do
        expect('Product 1').to appear_before('Product 2')
      end
    end

    specify 'I can sort search results by descending order' do
      (1..9).each do |i|
        FactoryBot.create(:product, name: "Product #{i}", url: "https://www.test#{i}")
      end
      visit products_path
      fill_in 'q_name_or_description_or_manufacturer_or_category_name_cont', with: 'Product'
      click_button
      find('a', text: 'Name').click
      find('a', text: 'Name').click

      within(:css, '.products') do
        expect('Product 2').to appear_before('Product 1')
      end
    end

    specify 'I cannot perform an XSS injection attack' do
      visit '/'
      fill_in 'q_name_or_description_or_manufacturer_or_category_name_cont', with: '
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
      fill_in 'q_name_or_description_or_manufacturer_or_category_name_cont', with: "TestName') OR 'SQLTest'--"
      click_button
      expect(page).to have_content "'TestName') OR 'SQLTest'--"
    end
  end
end
