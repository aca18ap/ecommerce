# frozen_string_literal: true

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
  let!(:customer) { FactoryBot.create(:customer) }
  let!(:product) { FactoryBot.create(:product) }
  subject { described_class.new(customer_id: customer.id, product_id: product.id) }

  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without a customer' do
      subject.customer_id = ''
      expect(subject).not_to be_valid
    end

    it 'is invalid without a product' do
      subject.product_id = ''
      expect(subject).not_to be_valid
    end
  end
end
