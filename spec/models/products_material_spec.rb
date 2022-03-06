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
  pending "add some examples to (or delete) #{__FILE__}"
end
