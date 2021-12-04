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

  def record_metrics
    head :ok
  end

  def review_usefulness
    @r = Review.find(params[:id].to_i)
    a = @r.rating
    @r.update_attribute(:rating, a+1)
  end

end
