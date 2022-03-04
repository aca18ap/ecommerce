# frozen_string_literal: true

# == Schema Information
#
# Table name: staffs
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default(1)
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_staffs_on_email                 (email) UNIQUE
#  index_staffs_on_invitation_token      (invitation_token) UNIQUE
#  index_staffs_on_invited_by            (invited_by_type,invited_by_id)
#  index_staffs_on_invited_by_id         (invited_by_id)
#  index_staffs_on_reset_password_token  (reset_password_token) UNIQUE
#  index_staffs_on_unlock_token          (unlock_token) UNIQUE
#
class Staff < ApplicationRecord
  include DeviseInvitable::Inviter

  enum role: { admin: 0, reporter: 1 }

  devise :invitable, :database_authenticatable, :password_archivable, :recoverable,
         :rememberable, :secure_validatable, :lockable, :registerable, invite_for: 2.weeks
end
