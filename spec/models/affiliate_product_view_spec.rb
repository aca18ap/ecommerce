# frozen_string_literal: true

# == Schema Information
#
# Table name: affiliate_product_views
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint           not null
#  product_id  :bigint           not null
#
# Indexes
#
#  index_affiliate_product_views_on_customer_id  (customer_id)
#  index_affiliate_product_views_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (product_id => products.id)
#
require 'rails_helper'

RSpec.describe AffiliateProductView, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
