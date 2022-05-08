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
#  index_categories_on_name      (name)
#
class Category < ApplicationRecord
  has_ancestry
  has_many :products
  validates :name, presence: true

  # Only over products.size because this method is called on after_save hook
  # needed to -1 the product.size corresponding to the old average.
  def add_to_mean_co2(product)
    update(mean_co2: (((products.size - 1) * mean_co2) + product.co2_produced) / products.size)
  end

  # Product count still returning 1 even on after destroy
  def sub_from_mean_co2(product)
    mean = ((products.size * mean_co2) - product.co2_produced) / (products.size - 1)
    mean = 0 if mean.nan?
    update(mean_co2: mean)
  end

  def refresh_average
    update(mean_co2: (products.sum(:co2_produced) / products.size))
  end
end
