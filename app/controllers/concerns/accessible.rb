# frozen_string_literal: true

module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected

  def check_user
    if current_staff
      flash.clear
      redirect_to rails_admin.dashboard_path and return

    elsif current_business
      flash.clear
      redirect_to authenticated_business_root_path and return

    elsif current_customer
      flash.clear
      redirect_to authenticated_customer_root_path and return
    end
  end
end
