# frozen_string_literal: true

require 'rails_helper'

describe 'Managing Products' do
  describe 'When I am logged in as an admin' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    let!(:product) { FactoryBot.create(:product) }

    specify 'I can see edit and destroy for products' do
      visit product_path(product)
      expect(page).to have_content 'Edit'
      expect(page).to have_content 'Destroy'
    end

    specify 'I can edit a product\'s information' do
      visit product_path(product)
      click_link 'Edit'
      fill_in 'product[description]', with: 'a new description'
      select 'Italy', from: 'product[manufacturer_country]'
      click_button 'Update Product'

      expect(page).to have_content 'a new description'
    end

    specify 'I can destroy a product', js: true do
      visit product_path(product)
      expect(page).to have_content product.name

      accept_confirm do
        click_link 'Destroy'
      end

      expect(page).to_not have_content product.name
    end
  end

  describe 'When I am not logged in as an admin' do
    let!(:product) { FactoryBot.create(:product) }

    def check_page_for_links
      visit product_path(product)
      expect(page).to_not have_content 'Edit'
      expect(page).to_not have_content 'Destroy'
    end

    specify 'can see edit and destroy for products in the list if I am not logged in' do
      check_page_for_links
    end

    specify 'can see edit and destroy for products in the list if I am logged in as a customer' do
      login_as(FactoryBot.create(:customer), scope: :customer)
      check_page_for_links
    end

    specify 'can see edit and destroy for products in the list if I am logged in as a business' do
      login_as(FactoryBot.create(:business), scope: :business)
      check_page_for_links
    end

    specify 'can see edit and destroy for products in the list if I am logged in as a reporter' do
      login_as(FactoryBot.create(:reporter), scope: :reporter)
      check_page_for_links
    end
  end

  describe 'Security' do
    before { login_as(FactoryBot.create(:admin), scope: :staff) }
    let!(:product) { FactoryBot.create(:product) }

    specify 'I cannot perform an SQL injection attack' do
      visit edit_product_path(product)
      fill_in 'product[description]', with: "'); DROP products Products--"
      select 'Italy', from: 'product[manufacturer_country]'
      click_button 'Update Product'

      visit product_path(product)
      expect(page).to have_content "'); DROP products Products--"
    end

    specify 'I cannot perform an XSS attack' do
      visit edit_product_path(product)
      fill_in 'product[description]', with: "<h1>Hello</h1>
                                <script>
                                  $(function() {
                                    window.location.replace('http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html');
                                  });
                                </script>"
      select 'Italy', from: 'product[manufacturer_country]'
      click_button 'Update Product'

      visit product_path(product)
      sleep(2)
      expect(current_url).not_to eq 'http://api.rubyonrails.org/classes/ActionView/Helpers/SanitizeHelper.html'
      expect(page).to have_content '<h1>Hello</h1>'
    end
  end
end
