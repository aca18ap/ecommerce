# frozen_string_literal: true

# Decorator class for product view logic
class ProductDecorator < ApplicationDecorator
  delegate_all

  def business_name
    business ? business.name : 'Unknown'
  end

  def truncated_description
    return if description.nil? || description.empty?

    description.truncate(50, separator: /\w+/)
  end

  def co2_produced_with_unit
    "#{co2_produced}<sub>Kg of CO2</sub>".html_safe
  end

  def price_with_currency
    "£#{price}"
  end

  def product_image(height = nil, width = nil)
    if image.attached?
      meta = ActiveStorage::Analyzer::ImageAnalyzer.new(image).metadata
      height = meta['width'] if height.nil?
      width = meta['width'] if width.nil?
      h.image_tag(image, class: 'img-fluid', size: "#{height}x#{width}", alt: description)
    else
      h.image_tag('default-image.jpg', class: 'img-fluid', size: "#{height}x#{width}", alt: description)
    end
  end

  def product_image_thumbnail(height = nil, width = nil)
    if image.attached?
      meta = ActiveStorage::Analyzer::ImageAnalyzer.new(image).metadata
      height = meta['width'] if height.nil?
      width = meta['width'] if width.nil?
      h.image_tag(image, class: 'image-thumbnail', size: "#{height}x#{width}", alt: description)
    else
      h.image_tag('default-image.jpg', class: 'image-thumbnail', size: "#{height}x#{width}", alt: description)
    end
  end

  def materials_breakdown
    html_values = ''
    products_material.each do |m|
      name = m.material.name
      percentage = " #{m.percentage.to_i}%"
      html_values += h.tag.h6(name + percentage, class: 'breakdown')
    end
    html_values.html_safe
  end

  def greener_suggestions(suggestions)
    html_values = ''
    suggestions.each do |p|
      html_values += h.render partial: 'suggested_product_card', locals: { p: p.decorate }
    end
    html_values.html_safe
  end

  def co2_per_pound
    (co2_produced / price).round(2)
  end

  def mass_with_unit
    "#{product.mass.round(2)} kg"
  end

  def number_of_views
    return '0 Views' if business_id.nil?

    count = affiliate_product_views.count
    "#{count} View#{count > 1 ? 's' : ''}"
  end

  def full_country_name
    Country.new(manufacturer_country).common_name
  end

  ## https://www.carbonindependent.org/17.html#:~:text=A%20second%20estimate%20(not%20used,i.e.%20a%20considerably%20higher%20estimate.
  def co2_in_car_km
    "#{(difference_with_mean / 0.099).round(2).abs}<sub>km</sub>".html_safe
  end

  def difference_with_mean
    (category.mean_co2 - co2_produced).round(2)
  end

  def difference_formatted
    "#{difference_with_mean.abs}<sub>Kg of CO2</sub>".html_safe
  end

  def leaderboard_mini
    html_values = ''
    product.category.products.order(:kg_co2_per_pounds).each_with_index do |p, i|
      p.co2_per_pounds if p.kg_co2_per_pounds.nil?
      css_class = if p.id == id
                    'lboard_text_this flex-fill'
                  else
                    'flex-fill lboard_text'
                  end
      html_values += "<a class=#{css_class} href=/products/#{p.id}>"
      html_values += "#{i + 1} | #{p.name} <sub>#{p.kg_co2_per_pounds.round(3)}</sub></a><br>"
    end
    html_values.html_safe
  end

end
