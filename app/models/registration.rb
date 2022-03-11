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
class Registration < ApplicationRecord
  validates :vocation, presence: true

  enum vocation: { customer: 0, business: 1 }

  # Gets the 'created_at' time truncated to the nearest hour
  def hour
    DateTime.parse(created_at.to_s).change({ min: 0, sec: 0 })
  end
end
