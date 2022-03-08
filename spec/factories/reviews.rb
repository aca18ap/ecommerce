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
FactoryBot.define do
  factory :review do
    id { 1 }
    description { 'MyText' }
    rating { 1 }
    rank { 1 }
    hidden { false }

    factory :second_review do
      id { 2 }
      description { 'MySecondText' }
      rank { 1 }
    end

    factory :hidden_review do
      id { 3 }
      description { 'MyHiddenText' }
      hidden { true }
    end
  end
end
