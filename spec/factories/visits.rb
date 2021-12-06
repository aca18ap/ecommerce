# == Schema Information
#
# Table name: visits
#
#  id                 :bigint           not null, primary key
#  csrf_token         :string
#  from               :datetime
#  location           :string
#  path               :string
#  session_identifier :string
#  to                 :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#
FactoryBot.define do
  factory :visit do
    from { "2021-11-27 16:39:22" }
    to { "2021-11-27 16:39:22" }
    csrf_token { "MyString" }
    path { "MyString" }
    user_id { 1 }
    session_identifier { "MyString" }
  end
end
