# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletters
#
#  id         :bigint           not null, primary key
#  email      :string
#  vocation   :string           default("Customer"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :newsletter do
    factory :free_customer_newsletter do
      email { 'freecustomer@team04.com' }
      vocation { 'Customer' }
      tier { 'Free' }
    end

    factory :solo_customer_newsletter do
      email { 'solocustomer@team04.com' }
      vocation { 'Customer' }
      tier { 'Solo' }
    end

    factory :family_customer_newsletter do
      email { 'familycustomer@team04.com' }
      vocation { 'Customer' }
      tier { 'Family' }
    end

    factory :business_newsletter do
      email { 'business@team04.com' }
      vocation { 'Business' }
    end
  end
end
