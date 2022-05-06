# frozen_string_literal: true

# Product Controller handles management requests of products
class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :authenticate_staff!, except: %i[show index new create destroy]
  before_action :load_categories, only: %i[new create edit update]
  after_action :affiliate_view, only: :show
  authorize_resource
  decorates_assigned :products, :product

  # GET /products
  def index
    @products = Product.with_attached_image.where(nil).includes(:materials)
    filtering_params(params).each do |key, value|
      @products = @products.public_send("filter_by_#{key}", value) if value.present?
    end
    @products = @products.paginate(page: params[:page], per_page: 12).order(params['sort_by'])
    @products = @products.reverse_order if params['order_by'] == 'descending'
  end

  # GET /products/1
  def show
    @suggestions = load_suggestions
    @product = @product.decorate
    @co2 = Co2Calculator.new(@product)
    @country = Country.new(@product.manufacturer_country)
    @uk = Country.new('GB')
    gon.push({ lat1: @uk.latitude, long1: @uk.longitude, lat2: @country.latitude, long2: @country.longitude })
  end

  # GET /products/new
  def new
    if current_customer || current_staff || current_business
      @product = Product.new
      @product.products_material.build
    else
      redirect_to new_customer_registration_path, alert: 'You need to sign up before adding a new product!'
    end
  end

  # GET /products/1/edit
  def edit; end

  # POST /products
  def create
    @product = Product.new(current_user_params)

    if @product.save
      # Add product to customer purchase history
      @product.customers << current_customer if current_customer && product_params[:customer_purchased] == '1'
      @product.image.attach(params[:product][:image])
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /products/1
  def update
    old_cat = @product.category
    if @product.update(product_params.except(:customer_purchased))
      if old_cat.id != @product.category_id
        @product.category.refresh_average
        old_cat.refresh_average
      end
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy

    redirect_to products_path, notice: 'Product was successfully destroyed.' and return unless current_business

    head :ok if @product.destroyed?
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :description, :business_id, :mass, :price, :url, :manufacturer,
                                    :manufacturer_country, :co2_produced, :image, :customer_purchased, :category_id,
                                    products_material_attributes: %i[material_id percentage id _destroy])
  end

  # Set specific product parameters for if the current user is a business, a customer or a staff member
  def current_user_params
    if current_business
      product_params.merge(business_id: current_business.id).except(:image, :customer_purchased)
    else
      product_params.except(:image, :customer_purchased)
    end
  end

  # List of params that can be used to filter products if specified
  def filtering_params(params)
    params.slice(:name, :similarity, :search_term, :business_id)
  end

  # Creates a view in the affiliate product views table if the product shown is associated with a business
  def affiliate_view
    # Insert affiliate view if a customer views an affiliate product
    return if @product.business_id.nil? || !current_customer

    AffiliateProductView.new(product_id: @product.id, customer_id: current_customer.id).save
  end

  def load_categories
    gon.push({ categories: Category.arrange_serializable })
  end

  def load_suggestions
    related_products = Category.find(@product.category_id).products.where.not(id: @product.id)
    related_products.where('co2_produced < :mean_co2', { mean_co2: @product.category.mean_co2 })
  end
end
