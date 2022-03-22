# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewDecorator do
  let(:review) { FactoryBot.create(:review).decorate }

  describe '.truncated_description' do
    context 'If a review description is under 120 characters long' do
      it 'returns the full review description' do
        review.description = 'Under 120 characters'
        expect(review.truncated_description).to eq review.description
      end
    end

    context 'If a review description is over 120 characters long' do
      it 'returns 117 characters with an ellipse if the review description is more than 120 characters long' do
        review.description = 'a' * 121
        expect(review.truncated_description).to eq "#{'a' * 117}..."
      end
    end

    context 'If a review description is nil or empty' do
      it 'returns nothing' do
        review.description = nil
        expect(review.truncated_description).to eq nil

        review.description = ''
        expect(review.truncated_description).to eq nil
      end
    end
  end
end
