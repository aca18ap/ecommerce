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
class Share < ApplicationRecord
  validates :feature, presence: true
  validates :social, presence: true
end
