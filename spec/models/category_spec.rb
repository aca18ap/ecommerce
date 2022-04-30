# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  ancestry    :string
#  average_co2 :float
#  mean_co2    :float            default(0.0), not null
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_categories_on_ancestry  (ancestry)
#
require 'rails_helper'

RSpec.describe Category, type: :model do
  let!(:category) { FactoryBot.create(:category) }

  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(category).to be_valid
    end

    it 'is invalid without name' do
      category.name = ''
      expect(category).not_to be_valid
    end

    it 'is valid without sub-categories' do
      expect(category.children.length).to eq 0
    end
  end

  describe 'Category hierarchy' do
    let(:sub_category) { category.children.create(name: 'Sub-Category') }

    it 'a sub-category belongs to a category' do
      expect(sub_category.parent).not_to be_nil
    end

    it 'a category can have children' do
      expect(category.children).not_to be_nil
    end
  end

  describe '.update_mean_co2' do
    it 'maintains a record of average co2 for the category' do
      category.products << FactoryBot.create(:product)
      expected_mean = category.products.sum(&:co2_produced) / category.products.size.to_f

      category.update_mean_co2
      expect(category.mean_co2).to eq expected_mean
    end
  end
end
