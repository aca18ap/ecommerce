# frozen_string_literal: true

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
# Indexes
#
#  index_visits_on_path  (path)
#
class Visit < ApplicationRecord
  # Gets the 'from' time truncated to the nearest hour
  def hour
    DateTime.parse(from.to_s).change({ min: 0, sec: 0 })
  end
end
