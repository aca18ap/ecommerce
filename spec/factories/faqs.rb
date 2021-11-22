# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :text
#  clicks     :integer
#  hidden     :boolean
#  question   :text
#  usefulness :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :faq do
    question { "MyText" }
    answer { "MyText" }
    clicks { 1 }
    hidden { false }
    usefulness { 1 }
  end
end
