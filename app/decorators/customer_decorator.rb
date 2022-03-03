# frozen_string_literal: true

class CustomerDecorator < Draper::Decorator
  delegate_all

  def unlock_button?
    return unless access_locked?

    h.link_to 'Unlock', h.unlock_customer_path(id),
              method: :patch, class: 'btn btn-xs',
              data: { confirm: 'Are you sure you want to unlock this account?' }
  end

end
