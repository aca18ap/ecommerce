class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:new, :create, :show, :created]

  authorize_resource

  # GET /reviews
  def index
    @reviews = Review.order('created_at DESC').all.decorate
  end

  # GET /reviews/1
  def show; end

  # GET /created/
  def created; end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
    @error_msg = 0
  end

  # POST /reviews
  def create
    @review = Review.new(review_params)

    if @review.save
      if current_user && current_user.admin?
        redirect_to @review, notice: 'Review was successfully created.'
      else
        redirect_to review_created_path, notice: 'Review was successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /reviews/1
  def update
    if review_params[:hidden].to_i.zero? && review_params[:rank].to_i.zero?
      @error_msg = 2
      render :edit
    elsif review_params[:hidden].to_i != 0 && review_params[:rank].to_i.positive?
      @error_msg = 1
      render :edit
    elsif @review.update(review_params)
      redirect_to @review, notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /reviews/1
  def destroy
    @review.destroy
    redirect_to reviews_url, notice: 'Review was successfully destroyed.'
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
