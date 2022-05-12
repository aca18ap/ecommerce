# frozen_string_literal: true

# Reviews controller handles all functionality relating to reviews
class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show edit update destroy]
  before_action :authenticate_staff!, except: %i[new create show created]

  authorize_resource

  # GET /reviews
  def index
    @reviews = Review.order('created_at DESC').all.decorate
  end

  # GET /reviews/1
  def show; end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit; end

  # POST /reviews
  def create
    @review = Review.new(review_params)

    if @review.save
      redirect_to root_path, notice: 'Thank you for leaving feedback!'
    else
      render :new
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if @review.update(review_params)
      redirect_to root_path, notice: 'Review was successfully updated.'
    else
      redirect_to edit_review_path, alert: @review.errors.full_messages.first
    end
  end

  # DELETE /reviews/1
  def destroy
    @review.destroy
    redirect_to root_path, notice: 'Review was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = Review.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def review_params
    params.require(:review).permit(:description, :clicks, :rating, :hidden, :rank)
  end
end
