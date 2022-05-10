# frozen_string_literal: true

require 'rails_helper'

# Bug causing a 500 error when trying to delete a material that has dependent products
describe 'Regression test for material delete bug' do
  before { login_as(FactoryBot.create(:admin), scope: :staff) }
  let!(:material) { FactoryBot.create(:material) }

  specify 'I can delete a material that has no dependent products' do
    visit materials_path
    click_link 'Destroy'
    expect(page).to have_content 'Material was successfully destroyed.'
    expect(Material.count).to eq 0
  end

  specify 'I can delete a material that has no dependent products' do
    material.products << FactoryBot.create(:product)
    visit materials_path
    click_link 'Destroy'
    expect(page).to have_content 'Cannot delete material. Products with this material exist.'
    expect(Material.find(material.id)).to eq material
  end
end

# Bug meaning product co2 produced is not updated if material CO2 updated
describe 'Regression test for product co2 produced update' do
  before { login_as(FactoryBot.create(:admin), scope: :staff) }
  let!(:product) { FactoryBot.create(:product) }

  specify 'Product CO2 is updated if material CO2 is changed. The category mean is also updated' do
    initial_co2_produced = product.co2_produced

    material = product.materials.first
    material.update(kg_co2_per_kg: material.kg_co2_per_kg + 10)
    expect(product.reload.co2_produced).to_not eq initial_co2_produced

    expect(product.category.mean_co2).to eq product.co2_produced
  end
end
