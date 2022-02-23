# frozen_string_literal: true

class ShareDecorator < Draper::Decorator
  delegate_all

  def social_feature(social, feature)
    f = get_feature_text(feature)
    msg_as_query = f.gsub(' ','%20')
    if social == "facebook"
      url = "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2F" + f + "%2F%23&src=sdkpreparse"
    elsif social == "twitter"
      url = "https://twitter.com/intent/tweet?text=" + f
    end
    return url
  end

  def get_feature_text(feature)
    case feature
    when "Unlimited suggestions"
      "Get unlimited greener suggestions with our premium plan @ecommerce"
    when "One-click Visit retailer"
      "Instant link to greener retailers through @ecommerce"
    when "24/7 Support"
      "Get instant support through our live chat, available 24/7 on @ecommerce"
    when "One-click access"
      "Purchase greener products directly throguh @ecommerce"
    when "View purchase history"
      "Visualize your purchase history and see how green you are compared to friends and family! Only on @ecommerce"
    when "View carbon footprint"
      "Quick access to your carbon footprint, save the planet click by click on @ecommerce"
    when "Family purchase history"
      "Watch you and your family destroy the world at x4 the speed! On @ecommerce"
    else
      "@ecommerce saving the planet click by click"
    end
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end
