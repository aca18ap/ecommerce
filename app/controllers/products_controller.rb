class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
<<<<<<< HEAD
  before_action :authenticate_customer! || :authenticate_staff!, only: [:new, :create]
  before_action :authenticate_staff!, except: [:show, :index, :new, :create]
=======
  before_action :authenticate_user!, except: [:show, :index]
>>>>>>> Added authentication check to creating products, refactored column type to category due to rails complaining
  # GET /products
  def index
    @products = Product.order('created_at DESC').all.decorate
  end

  # GET /products/1
  def show

  end

  # GET /products/new
  def new
    @product = Product.new
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
    # Set user authorization
    def validate_user
      if customer?
        before_action :authenticate_customer!, only: [:new, :create, :index]
      elsif admin? 
        before_action :authenticate_staff!
      end
    end

        

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
<<<<<<< HEAD
      params.require(:product).permit(:name, :description, :mass, :category, :url, :manufacturer,  :manufacturer_country, :co2_produced, :material_ids => [])
=======
      params.require(:product).permit(:name, :description, :mass, :category, :url, :manufacturer, :manufacturer_country, :co2_produced)
>>>>>>> Added authentication check to creating products, refactored column type to category due to rails complaining
    end
end
