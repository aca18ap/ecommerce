# frozen_string_literal: true

# == Schema Information
#
# Table name: product_reports
#
#  id          :bigint           not null, primary key
#  content     :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  business_id :bigint
#  customer_id :bigint
#  product_id  :bigint           not null
#  staff_id    :bigint
#
# Indexes
#
#  index_product_reports_on_business_id  (business_id)
#  index_product_reports_on_customer_id  (customer_id)
#  index_product_reports_on_product_id   (product_id)
#  index_product_reports_on_staff_id     (staff_id)
#
# Foreign Keys
#
#  fk_rails_...  (business_id => businesses.id)
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (staff_id => staffs.id)
#
FactoryBot.define do
  factory :product_report do
    product { FactoryBot.create(:product) }
    customer { FactoryBot.create(:customer) }
    business { nil }
    staff { nil }
    content { 'MyString' }
  end
end
