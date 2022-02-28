# frozen_string_literal: true

# Manages which pages logged in users can access based on their user type
module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected

  def check_user

    if current_staff
      flash.clear
      redirect_to staffs_show_path and return

    elsif current_business
      flash.clear
      redirect_to businesses_show_path and return

    elsif current_customer
      flash.clear
      redirect_to customers_show_path and return
    end
  end
end
