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
  let!(:product) { FactoryBot.create(:product, business_id: 1) }
  let!(:customer) { FactoryBot.create(:customer) }
  subject { described_class.new(product_id: product.id, customer_id: customer.id) }

  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without a product_id' do
      subject.product_id = nil
      expect(subject).not_to be_valid
    end

    it 'is invalid without a customer_id' do
      subject.customer_id = nil
      expect(subject).not_to be_valid
    end
  end
end
