# frozen_string_literal: true

# Decorator class for customer view logic
class CustomerDecorator < Draper::Decorator
  delegate_all
  decorates_association :products

  def unlock_button?
    return unless access_locked?

    h.link_to 'Unlock', h.unlock_customer_url(id),
              method: :patch, class: 'btn btn-xs',
              data: { confirm: 'Are you sure you want to unlock this account?' }
  end

  def mean_co2_per_purchase
    # TODO: Change CustomerMetrics calculation to be offline and fetch offline calculation instead
    if products.size.zero?
      return { customer: 'N/A', site: CustomerMetrics.site_mean_co2_per_purchase,
               valence: 'average' }
    end

    customer = (products.map(&:co2_produced).sum / products.size).round(1)
    site = CustomerMetrics.site_mean_co2_per_purchase
    {
      customer: customer,
      site: site,
      valence: calculate_valence(customer, site)
    }
  end

  def total_co2_produced
    return { customer: 'N/A', site: CustomerMetrics.site_total_co2_produced, valence: 'average' } if products.size.zero?

    customer = products.map(&:co2_produced).sum.round(1)
    site = CustomerMetrics.site_total_co2_produced
    {
      customer: customer,
      site: site,
      valence: calculate_valence(customer, site)
    }
  end

  def co2_saved
    return { customer: 'N/A', site: CustomerMetrics.site_co2_saved, valence: 'average' } if products.size.zero?

    customer = products.map { |p| p.category.mean_co2 - p.co2_produced }.sum.round(1)
    site = CustomerMetrics.site_co2_saved

    {
      customer: customer,
      site: site,
      valence: calculate_valence(site, customer)
    }
  end

  def co2_per_pound
    return { customer: 'N/A', site: CustomerMetrics.site_co2_per_pound, valence: 'average' } if products.size.zero?

    customer = (products.map(&:co2_produced).sum / products.map(&:price).sum).round(1)
    site = CustomerMetrics.site_co2_per_pound
    {
      customer: customer,
      site: site,
      valence: calculate_valence(customer, site)
    }
  end

  def products_total
    return { customer: 0, site: CustomerMetrics.site_products_total, valence: 'average' } if products.size.zero?

    customer = products.length
    site = CustomerMetrics.site_products_total
    {
      customer: customer,
      site: site,
      valence: calculate_valence(site, customer)
    }
  end

  private

  # Compares customer statistics against site average
  def calculate_valence(exp_smaller, exp_larger)
    if exp_smaller < exp_larger
      'good'
    elsif exp_smaller == exp_larger
      'average'
    else
      'bad'
    end
  end
end
