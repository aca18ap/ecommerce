# frozen_string_literal: true

# == Schema Information
#
# Table name: products_materials
#
#  id          :bigint           not null, primary key
#  percentage  :float
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
class ProductsMaterial < ApplicationRecord
  belongs_to :product, inverse_of: :products_material
  belongs_to :material
end
