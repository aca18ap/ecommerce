# frozen_string_literal: true

# Categories controll for staff to manage product acetgories
class CategoriesController < ApplicationController
  before_action :authenticate_staff!, except: %i[index show]
  before_action :set_category, only: %i[show edit update destroy]
  decorates_assigned :categories, :category

  # GET /categories
  def index
    @categories = Category.roots.with_attached_image.decorate
  end

  # GET /categories/1
  def show
    @products = @category.products.includes([:image_attachment]).paginate(page: params[:page], per_page: 24)
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit; end

  # POST /categories
  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to @category, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      redirect_to @category, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Category was successfully destroyed.'
  end

  def search; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def category_params
    params.require(:category).permit(:name, :parent_id, :image)
  end
end
