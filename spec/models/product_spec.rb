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
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:product) { FactoryBot.create(:product)}
  subject{described_class.new(name: 'Product', category: 'Category', manufacturer: 'Me', mass: '10', url: 'test.com', manufacturer_country: 'Country')}
  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without name' do
      subject.name = ''
      expect(subject).not_to be_valid
    end
    it 'is invalid without category' do
      subject.category = ''
      expect(subject).not_to be_valid
    end
    it 'is invalid without manufacturer' do
      subject.manufacturer = ''
      expect(subject).not_to be_valid
    end
    it 'is invalid without mass' do
      subject.mass = ''
      expect(subject).not_to be_valid
    end
    it 'is invalid without manufacturer country' do
      subject.manufacturer_country = ''
      expect(subject).not_to be_valid
    end
  end
end
