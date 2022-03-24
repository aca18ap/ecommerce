# frozen_string_literal: true

# Decorator class for customer view logic
class CustomerDecorator < Draper::Decorator
  delegate_all

  def unlock_button?
    return unless access_locked?

    h.link_to 'Unlock', h.unlock_customer_url(id),
              method: :patch, class: 'btn btn-xs',
              data: { confirm: 'Are you sure you want to unlock this account?' }
  end

  def mean_co2_per_purchase
    return 'N/A' if products.size.zero?

    (products.map(&:co2_produced).sum / products.size).round(1)
  end

  def total_co2_produced
    return 'N/A' if products.size.zero?

    products.map(&:co2_produced).sum.round(1)
  end

  def co2_saved
    return 'N/A' if products.size.zero?

    'N/A'
  end

  def mean_co2_per_pound
    return 'N/A' if products.size.zero?

    'N/A'
    # products.map(&:co2_produced).sum / products.map(&:price)
  end
end
