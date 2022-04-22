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
require 'rails_helper'

RSpec.describe ProductReport, type: :model do
  let!(:product_report) { FactoryBot.create(:product_report) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(product_report).to be_valid
    end

    it 'is invalid without content' do
      product_report.content = nil
      expect(product_report).not_to be_valid
    end

    it 'is invalid without product' do
      product_report.product = nil
      expect(product_report).not_to be_valid
    end

    it 'is invalid without any user' do
      product_report.customer = nil
      product_report.business = nil
      product_report.staff = nil
      expect(product_report).not_to be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:product).without_validating_presence }
    it { should belong_to(:customer).without_validating_presence }
    it { should belong_to(:business).without_validating_presence }
    it { should belong_to(:staff).without_validating_presence }
  end
end
