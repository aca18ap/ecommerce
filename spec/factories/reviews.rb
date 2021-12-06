# == Schema Information
#
# Table name: reviews
#
#  id          :bigint           not null, primary key
#  clicks      :integer          default(0), not null
#  description :text             not null
#  hidden      :boolean          default(TRUE)
#  rank        :integer          default(0)
#  rating      :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :review do
    description { "MyText" }
    clicks { 1 }
    rating { 1 }
    hidden { false }
    rank { 1 }
  end
end
