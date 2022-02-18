# frozen_string_literal: true

FactoryBot.define do
  factory :faq do
    question { 'MyQuestion' }
    answer { 'MyAnswer' }
    clicks { 0 }
    hidden { false }
    usefulness { 0 }
  end

  trait :with_upvote do
    after(:create) do |f|
      create(:faq_vote, faq_id: f.id)
    end
  end

  trait :with_downvote do
    after(:create) do |f|
      create(:faq_vote, faq_id: f.id, value: -1)
    end
  end
end
