# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                   :bigint           not null, primary key
#  category             :string
#  co2_produced         :float
#  description          :string
#  manufacturer         :string
#  manufacturer_country :string
#  mass                 :float
#  name                 :string
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  business_id          :bigint
#
FactoryBot.define do
  factory :product, class: Product do
    name { 'TestName' }
    description { 'A piece of clothing' }
    mass { '14' }
    category { 'Trousers' }
    url { 'clothes.com' }
    manufacturer { 'Me' }
    manufacturer_country { 'Italy' }
    after(:create) do |product|
      product.materials ||= create(:material, product: product)
    end
  end
end
