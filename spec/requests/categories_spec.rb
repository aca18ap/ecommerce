# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/categories', type: :requrest do

    let!(:valid_attributes) {:category, name: 'Category'}
    let!(:invalid_attributes) {:category,  name: '' }

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

