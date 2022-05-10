# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
#
#  id         :bigint           not null, primary key
#  latitude   :float
#  longitude  :float
#  vocation   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_registrations_on_vocation  (vocation)
#
class Registration < ApplicationRecord
  validates :vocation, presence: true

  enum vocation: { customer: 0, business: 1 }
end
