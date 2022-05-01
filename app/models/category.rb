# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  ancestry   :string
#  mean_co2   :float            default(0.0), not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_ancestry  (ancestry)
#
class Category < ApplicationRecord
  has_ancestry
  has_many :products
  validates :name, presence: true

  # Only over products.size because this method is called on after_save hook
  def add_to_mean_co2(product)
    update(mean_co2: ((products.size * mean_co2) + product.co2_produced) / products.size)
  end

  # Only over products.size because this method is called on after_destroy hook
  def sub_from_mean_co2(product)
    update(mean_co2: ((products.size * mean_co2) - product.co2_produced) / products.size)
  end
end
