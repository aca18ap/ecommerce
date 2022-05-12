# frozen_string_literal: true

# Decorator class for category view logic
class CategoryDecorator < Draper::Decorator
  delegate_all

  def category_thumbnail(height = nil, width = nil)
    if image.attached?
      meta = ActiveStorage::Analyzer::ImageAnalyzer.new(image).metadata
      height = meta['width'] if height.nil?
      width = meta['width'] if width.nil?
      h.image_tag(image, class: 'img-fluid', size: "#{height}x#{width}", alt: name)
    else
      h.image_tag('default-image.jpg', class: 'img-fluid', size: "#{height}x#{width}", alt: name)
    end
  end
end
