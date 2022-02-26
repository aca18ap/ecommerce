# frozen_string_literal: true

# == Schema Information
#
# Table name: shares
#
#  id         :bigint           not null, primary key
#  feature    :string           not null
#  social     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :share do
    social { 'MySocial' }
    feature { 'MyFeature' }
  end
end
