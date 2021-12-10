# == Schema Information
#
# Table name: shares
#
#  id         :bigint           not null, primary key
#  count      :integer
#  feature    :string
#  social     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :share do
    count { 1 }
    social { "MyString" }
  end
end
