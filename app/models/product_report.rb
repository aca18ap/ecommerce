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
class ProductReport < ApplicationRecord
  validates :content, presence: true
  validates :product_id, presence: true
  belongs_to :product
  belongs_to :customer, optional: true
  belongs_to :staff, optional: true
  belongs_to :business, optional: true
  validate :one_user?

  private

  def one_user?
    number_of_users = 0
    number_of_users += 1 unless customer_id.blank?
    number_of_users += 1 unless business_id.blank?
    number_of_users += 1 unless staff_id.blank?
    return if number_of_users == 1

    errors.add(:base, "Provide exactly one user (#{number_of_users} provided)")
  end
end
