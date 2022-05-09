# frozen_string_literal: true

# == Schema Information
#
# Table name: reviews
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  hidden      :boolean          default(TRUE)
#  rank        :integer          default(0)
#  rating      :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_reviews_on_rank    (rank)
#  index_reviews_on_rating  (rating)
#
class Review < ApplicationRecord
  validates :description, presence: true
  validates :rank, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, numericality: { greater_than_or_equal_to: 0 }
  validate :hidden_and_rank

  private

  def hidden_and_rank
    if !hidden? && rank.zero?
      errors.add(:rank, 'should not be 0 for review to be shown on the front page')
    elsif hidden? && rank.positive?
      errors.add(:rank, 'should be 0 if review is hidden from the front page')
    end
  end
end
