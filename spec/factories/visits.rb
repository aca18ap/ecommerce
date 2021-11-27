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
