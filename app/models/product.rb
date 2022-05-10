# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                   :bigint           not null, primary key
#  co2_produced         :float
#  description          :string
#  kg_co2_per_pounds    :float
#  manufacturer         :string
#  manufacturer_country :string
#  mass                 :float
#  name                 :string
#  price                :float            default(0.0), not null
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  business_id          :bigint
#  category_id          :integer
#
# Indexes
#
#  index_products_on_business_id        (business_id)
#  index_products_on_category_id        (category_id)
#  index_products_on_co2_produced       (co2_produced)
#  index_products_on_kg_co2_per_pounds  (kg_co2_per_pounds)
#  index_products_on_name               (name)
#  index_products_on_price              (price)
#
class Product < ApplicationRecord
  # Scopes defined to clean up controller
  scope :filter_by_business_id, ->(business_id) { where business_id: business_id }
  scope :filter_by_similarity, ->(name) { where(name: name) }
  scope :filter_by_search_term, lambda { |name|
                                  where('name like ? OR manufacturer like ?', "#{name}%", "#{name}%")
                                }

  validates :name, :category, :url, :manufacturer, :manufacturer_country, :mass, :price, presence: true
  validates :url, uniqueness: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  validates :mass, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }
  validate :validate_percentages

  after_save :co2
  after_save :add_to_category_mean
  after_save :co2_per_pounds
  after_destroy :sub_from_category_mean

  has_one_attached :image, dependent: :destroy

  has_many :product_report, dependent: :destroy

  has_many :products_material, inverse_of: :product, dependent: :destroy
  has_many :materials, through: :products_material

  has_many :purchase_histories, dependent: :destroy
  has_many :customers, through: :purchase_histories

  has_many :affiliate_product_views, dependent: :destroy

  belongs_to :business, optional: true

  belongs_to :category

  accepts_nested_attributes_for :products_material, allow_destroy: true

  # Validation for materials percentages to add up to 100
  def validate_percentages
    pms = products_material.select { |m| m.marked_for_destruction? == false }.map(&:percentage).sum.to_i
    errors.add :products_material, 'Materials should add up to 100%' if pms != 100
  end

  def co2_per_pounds
    update_column(:kg_co2_per_pounds, co2_produced / price)
  end

  def update_metrics
    co2
    co2_per_pounds
  end

  private

  # calculating and updating co2 produced after_save
  def co2
    co2 = Co2Calculator.new(self).calculate_co2
    update_column(:co2_produced, co2)
  end

  # Updates the category mean for the product just added
  def add_to_category_mean
    category.add_to_mean_co2(self)
  end

  # Updates the category mean for the product just removed
  def sub_from_category_mean
    category.sub_from_mean_co2(self)
  end
end
