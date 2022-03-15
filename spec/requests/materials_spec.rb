# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/materials', type: :request do
  # Material. As you add validations to Material, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { name: 'Name', kg_co2_per_kg: 5 }
  end

  let(:invalid_attributes) do
    { name: '', kg_co2_per_kg: '' }
  end

  before { login_as(FactoryBot.create(:admin), scope: :staff) }

  describe 'GET /index' do
    it 'renders a successful response' do
      Material.create! valid_attributes
      get materials_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      material = Material.create! valid_attributes
      get material_url(material)
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
      material = Material.create! valid_attributes
      get edit_material_url(material)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Material' do
        expect do
          post materials_url, params: { material: valid_attributes }
        end.to change(Material, :count).by(1)
      end

      it 'redirects to the created material' do
        post materials_url, params: { material: valid_attributes }
        expect(response).to redirect_to(material_url(Material.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Material' do
        expect do
          post materials_url, params: { material: invalid_attributes }
        end.to change(Material, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post materials_url, params: { material: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'NameUpdate', kg_co2_per_kg: 10 }
      end

      it 'updates the requested material' do
        material = Material.create! valid_attributes
        patch material_url(material), params: { material: new_attributes }
        material.reload
        expect(material.name).to eq 'NameUpdate'
      end

      it 'redirects to the material' do
        material = Material.create! valid_attributes
        patch material_url(material), params: { material: new_attributes }
        material.reload
        expect(response).to redirect_to(material_url(material))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        material = Material.create! valid_attributes
        patch material_url(material), params: { material: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested material' do
      material = Material.create! valid_attributes
      expect do
        delete material_url(material)
      end.to change(Material, :count).by(-1)
    end

    it 'redirects to the materials list' do
      material = Material.create! valid_attributes
      delete material_url(material)
      expect(response).to redirect_to(materials_url)
    end
  end

  describe 'If I am not logged in as an admin' do
    before { logout(:staff) }

    def check_routes
      material = Material.create! valid_attributes

      get materials_url
      expect(response).to_not be_successful

      get material_url(material)
      expect(response).to_not be_successful

      get new_material_url
      expect(response).to_not be_successful

      get edit_material_url(material)
      expect(response).to_not be_successful

      post materials_url, params: { material: valid_attributes }
      expect(response).to_not be_successful

      patch material_url(material), params: { material: valid_attributes }
      expect(response).to_not be_successful

      delete material_url(material)
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

    it 'does not let me access the routes if I am logged in as a reporter' do
      login_as(FactoryBot.create(:reporter), scope: :staff)
      check_routes
    end
  end
end
