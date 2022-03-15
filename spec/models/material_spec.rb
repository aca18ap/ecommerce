# frozen_string_literal: true

# == Schema Information
#
# Table name: materials
#
#  id            :bigint           not null, primary key
#  kg_co2_per_kg :float
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Material, type: :model do
  let!(:material) { FactoryBot.create(:material) }
  subject { described_class.new(name: 'Timber', kg_co2_per_kg: '21') }

  describe 'Validates' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without name' do
      subject.kg_co2_per_kg = ''
      expect(subject).not_to be_valid
    end
    it 'is invalid without co_per_kg' do
      subject.kg_co2_per_kg = ''
      expect(subject).not_to be_valid
    end
  end
end
