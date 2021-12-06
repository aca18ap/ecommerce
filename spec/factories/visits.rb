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
    from { '2021-11-27 16:39:22' }
    to { '2021-11-27 16:39:22' }
    csrf_token { 'MyString' }
    latitude { '53.958332' }
    longitude { '‑1.080278' }
    user_id { 1 }
    session_identifier { 'MyString' }

    factory :visit_root do
      path { '/' }
    end

    factory :visit_reviews do
      path { '/reviews' }
    end
  end
end
