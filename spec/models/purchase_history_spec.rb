# == Schema Information
#
# Table name: purchase_histories
#
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint           not null
#  product_id  :bigint           not null
#
# Indexes
#
#  index_purchase_histories_on_customer_id  (customer_id)
#  index_purchase_histories_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (product_id => products.id)
#
require 'rails_helper'

RSpec.describe PurchaseHistory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
