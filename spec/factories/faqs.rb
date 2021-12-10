# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :text
#  clicks     :integer          default(0), not null
#  hidden     :boolean
#  question   :text             not null
#  usefulness :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :faq do
    id  { 1 }
    question { "MyText" }
    answer { "MyText" }
    clicks { 0 }
    hidden { false }
    usefulness { 0 }
  end
end
