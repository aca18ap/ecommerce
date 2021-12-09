class PagesController < ApplicationController
  before_action :authenticate_user!, only: :show_users_list

  def home
    @current_nav_identifier = :home
    @reviews = Review.all.where(:hidden => false)
    @reviews = @reviews.order(:rank)
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

  def carbon_footprint_viewer
    @current_nav_identifier = :carboon_footprint_viewer
  end

  def extension_features
    @current_nav_identifier = :extension_features
  end

  def crowdsourced_features
    @current_nav_identifier = :crowdsourced_features
  end

  def review_usefulness
    @r = Review.find(params[:id].to_i)
    a = @r.rating
    @r.update_attribute(:rating, a+1)
  end

end
