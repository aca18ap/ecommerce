# frozen_string_literal: true

# Manages which pages logged in users can access based on their user type
module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected

  def check_user
    if current_staff&.admin?
      flash.clear
      redirect_to authenticated_admin_root_path

    elsif current_staff&.reporter?
      flash.clear
      redirect_to authenticated_reporter_root_path

    elsif current_business
      flash.clear
      redirect_to authenticated_business_root_path

    elsif current_customer
      flash.clear
      redirect_to authenticated_customer_root_path
    end
  end
end
