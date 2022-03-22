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
#  price                :float            not null
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  business_id          :bigint
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

  has_one_attached :image, dependent: :destroy

  has_many :products_material, inverse_of: :product, dependent: :destroy
  has_many :materials, through: :products_material
  belongs_to :business, optional: true
  has_many :purchase_history
  has_many :customers, through: :purchase_history

  accepts_nested_attributes_for :products_material, allow_destroy: true

  # Validation for materials percentages to add up to 100
  def validate_percentages
    pms = products_material.select { |m| m.marked_for_destruction? == false }.map(&:percentage).sum.to_i
    errors.add :products_material, 'Materials should add up to 100%' if pms != 100
  end

  # Gets the 'created_at' time truncated to the nearest hour
  def hour
    DateTime.parse(created_at.to_s).change({ min: 0, sec: 0 })
  end

  private

  # calculating and updating co2 produced after_save
  def co2
    co2 = Co2Calculator.new(materials, products_material, manufacturer_country, mass).calculate_co2
    update_column(:co2_produced, co2)
  end
end
