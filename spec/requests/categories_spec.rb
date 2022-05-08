# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/categories', type: :request do
  let(:parent_category) { FactoryBot.create(:category) }
  let!(:valid_attributes) do
    { name: 'Category', parent_id: parent_category.id }
  end
  let!(:invalid_attributes) do
    {  name: '', parent_id: '' }
  end

  before { login_as(create(:admin), scope: :staff) }

  describe 'GET /index' do
    it 'renders a successful response' do
      Category.create! valid_attributes
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

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_material_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      category = Category.create! valid_attributes
      get edit_category_url(category)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Category' do
        expect do
          post categories_url, params: { category: valid_attributes }
        end.to change(Category, :count).by(1)
      end

      it 'redirects to the created Category' do
        post categories_url, params: { category: valid_attributes }
        expect(response).to redirect_to(category_url(Category.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Category' do
        expect do
          post categories_url, params: { category: invalid_attributes }
        end.to change(Category, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post categories_url, params: { category: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'NameUpdate' }
      end

      it 'updates the requested Category' do
        category = Category.create! valid_attributes
        patch category_url(category), params: { category: new_attributes }
        category.reload
        expect(category.name).to eq 'NameUpdate'
      end

      it 'redirects to the Category' do
        category = Category.create! valid_attributes
        patch category_url(category), params: { category: new_attributes }
        category.reload
        expect(response).to redirect_to(category_url(category))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        category = Category.create! valid_attributes
        patch category_url(category), params: { category: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested Category' do
      category = Category.create! valid_attributes
      expect do
        delete category_url(category)
      end.to change(Category, :count).by(-1)
    end

    it 'redirects to the materials list' do
      category = Category.create! valid_attributes
      delete category_url(category)
      expect(response).to redirect_to(categories_url)
    end
  end

  describe 'If I am not logged in as an admin' do
    before { logout(:staff) }

    def check_routes
      category = Category.create! valid_attributes

      get categories_url
      expect(response).to be_successful

      get category_url(category)
      expect(response).to be_successful

      get new_category_url
      expect(response).to_not be_successful

      get edit_category_url(category)
      expect(response).to_not be_successful

      post categories_url, params: { category: valid_attributes }
      expect(response).to_not be_successful

      patch category_url(category), params: { category: valid_attributes }
      expect(response).to_not be_successful

      delete category_url(category)
      expect(response).to_not be_successful
    end

    it 'does not let me access the routes if I am not logged in' do
      check_routes
    end

    it 'does not let me access the routes if I am logged in as a customer' do
      login_as(FactoryBot.create(:customer), scope: :customer)
      check_routes
    end

    it 'does not let me access the routes if I am logged in as a business' do
      login_as(FactoryBot.create(:business), scope: :business)
      check_routes
    end
  end
end
