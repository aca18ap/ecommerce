# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @current_nav_identifier = :home
    @reviews = Review.all.where(hidden: false).decorate
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

  def thanks
    @current_nav_identifier = :thanks
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
    @review = Review.find(params[:id].to_i)
    review_rating = @review.rating
    @review.update_attribute(:rating, review_rating + 1)
  end
end
