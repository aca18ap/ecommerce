# == Schema Information
#
# Table name: products_materials
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  material_id :bigint           not null
#  product_id  :bigint           not null
#
# Indexes
#
#  index_products_materials_on_material_id  (material_id)
#  index_products_materials_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (material_id => materials.id)
#  fk_rails_...  (product_id => products.id)
#
require 'rails_helper'
RSpec.describe ProductsMaterial, type: :model do
  let!(:material) { FactoryBot.create(:material)}
  let!(:product) { FactoryBot.create(:product)}
  subject{described_class.new(material_id: material.id, product_id: product.id)}
  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without a material' do
      subject.material_id = ''
      expect(subject).not_to be_valid
    end
    it 'is invalid without a product' do
      subject.product_id = ''
      expect(subject).not_to be_valid
    end
  end
end
