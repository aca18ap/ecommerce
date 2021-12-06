# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string           default("customer"), not null
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    factory :admin do
      email { 'admin@team04.com' }
      password { 'Password123' }
      role { 'admin' }
    end

    factory :reporter do
      email { 'reporter@team04.com' }
      password { 'Password123' }
      role { 'reporter' }
    end

    factory :customer do
      email { 'customer@team04.com' }
      password { 'Password123' }
      role { 'customer' }
    end

    factory :business do
      email { 'business@team04.com' }
      password { 'Password123' }
      role { 'customer' }
    end
  end
end
