# frozen_string_literal: true

# Product Controller handles management requests of products
class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :authenticate_staff!, except: %i[show index new create]
  authorize_resource
  decorates_assigned :products, :product

  # GET /products
  def index
    @products = Product.where(nil)
    filtering_params(params).each do |key, value|
      @products = @products.public_send("filter_by_#{key}", value) if value.present?
    end
    @products = @products.paginate(page: params[:page], per_page: 10).order(params['sort_by'])
    @products = @products.reverse_order if params['order_by'] == 'descending'
  end

  # GET /products/1
  def show
    @product = @product.decorate
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
    if @product.update(product_params.except(:customer_purchased))
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_path, notice: 'Product was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(:name, :description, :business_id, :mass, :price, :category, :url, :manufacturer,
                                    :manufacturer_country, :co2_produced, :image, :customer_purchased,
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
end
