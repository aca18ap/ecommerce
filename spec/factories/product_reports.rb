# == Schema Information
#
# Table name: product_reports
#
#  id          :bigint           not null, primary key
#  content     :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint           not null
#  product_id  :bigint           not null
#
# Indexes
#
#  index_product_reports_on_customer_id  (customer_id)
#  index_product_reports_on_product_id   (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (product_id => products.id)
#
FactoryBot.define do
  factory :product_report do
    product { FactoryBot.create(:product) }
    customer { FactoryBot.create(:customer) }
    content { 'MyString' }
  end
end
