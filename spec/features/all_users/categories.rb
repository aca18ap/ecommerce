# frozen_string_literal: true

require 'rails_helper'

describe 'Categories' do
    context 'as a Customer' do
        let!(:category) { FactoryBot.create(:category, name: 'main_category') }
        let!(:sub_category) { FactoryBot.create(:category, name: 'sub_category', parent_id: category.id)} 
        let!(:sub_sub_category) { FactoryBot.create(:category, name: 'sub_sub_category', parent_id: sub_category.id)} 
        let!(:customer) { FactoryBot.create(:customer) }
        let!(:product) { FactoryBot.create(:product, category_id: category.id) } 
        let!(:sub_product) { FactoryBot.create(:product, url:'http://www.uuwd.com', name: 'sub_product', category_id: sub_category.id)}
        before { login_as(customer, scope: :customer) }
        
        specify 'I can view all products in a category' do
            visit category_path(category)
            expect(page).to have_content(product.name)
        end        
        
        specify 'I can view all products in a sub-category' do
            visit category_path(sub_category)
            expect(page).to have_content(sub_product.name)
        end
        
        specify 'I cannot view products taht don\'t belong to a category' do
            visit category_path(sub_sub_category)
            expect(page).to_not have_content(sub_product.name)
        end

        specify 'I can view all the categories in the navigation pane' do
            visit category_path(category)
            expect(page).to have_content(category.name)
            expect(page).to have_content(sub_category.name)
            expect(page).to have_content(sub_sub_category.name)
        end
    end
end

