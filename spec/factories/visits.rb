# == Schema Information
#
# Table name: visits
#
#  id                 :bigint           not null, primary key
#  csrf_token         :string
#  from               :datetime
#  latitude           :float
#  longitude          :float
#  path               :string
#  session_identifier :string
#  to                 :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#
FactoryBot.define do
  factory :visit do
    from { '2021-11-27 16:39:22' }
    to { '2021-11-27 16:39:22' }
    csrf_token { 'MyString' }
    user_id { 1 }

    factory :visit_root do
      path { '/' }
      session_identifier { 'session_1' }
    end

    factory :visit_reviews do
      path { '/reviews' }
      session_identifier { 'session_2' }
    end

    factory :visit_newsletters_new
    path { '/newsletters/1' }
    session_identifier { 'session_3' }
  end
end
