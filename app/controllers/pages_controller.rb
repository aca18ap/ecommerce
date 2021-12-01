class PagesController < ApplicationController
  before_action :authenticate_user!, only: :show_users_list

  def home
    @current_nav_identifier = :home
  end

  def pricing_plans
    @current_nav_identifier = :pricing_plans
  end

  def business_info
    @current_nav_identifier = :pricing_plans
  end


  def welcome
    @current_nav_identifier = :welcome
  end

  def record_metrics
    head :ok
  end

end
