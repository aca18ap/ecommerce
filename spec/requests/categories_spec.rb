# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/categories', type: :request do
    let(:parent_category) { FactoryBot.create(:category)}
    let!(:valid_attributes) do 
        { name: 'Category', parent_id: parent_category}
    end
    let!(:invalid_attributes) do 
        {  name: '', parent_id: '' }
    end

    describe 'GET /index' do
        it 'renders a successful response' do
            category = Category.create! valid_attributes
            get categories_url
            expect(response).to be_successful
        end
    end

    describe 'GET /show' do
        it 'renders a successful response' do
            category = Category.create! valid_attributes
            get category_url(category)
            expect(response).to be_successful
        end
    end
end