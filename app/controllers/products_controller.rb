class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate_customer! || :authenticate_staff!, only: [:new, :create]
  before_action :authenticate_staff!, except: [:show, :index, :new, :create]
  #before_action :validate_user
  # GET /products
  def index
    @products = Product.order('created_at DESC').all.decorate
  end

  # GET /products/1
  def show

  end

  # GET /products/new
  def new
    if current_customer || current_staff
      @product = Product.new
    else
      redirect_to new_customer_registration_path, alert: 'You need to sign up before adding a new product!'
    end
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end


  private

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :mass, :category, :url, :manufacturer,  :manufacturer_country, :co2_produced, :material_ids => [])
    end
end
