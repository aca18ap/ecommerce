# frozen_string_literal: true

# Decorator class for staff view logic
class StaffDecorator < Draper::Decorator
  delegate_all

  def unlock_button?
    return unless access_locked?

    h.link_to 'Unlock', h.unlock_staff_url(id),
              method: :patch, class: 'btn btn-xs',
              data: { confirm: 'Are you sure you want to unlock this account?' }
  end

  def invite_button?
    # If an invitation has been sent and not accepted
    return unless invitation_accepted_at.nil? && !invitation_created_at.nil?

    h.link_to 'Resend', h.invite_staff_url(id),
              method: :patch, class: 'btn btn-xs',
              data: { confirm: 'Resend invitation?' }
  end
end
