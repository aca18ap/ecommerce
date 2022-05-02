# frozen_string_literal: true

# Controller for managing purchases in customer's histories
class PurchaseHistoriesController < ApplicationController
  before_action :set_product, only: :destroy
  before_action :authenticate_customer!

  def new
    respond_to do |format|
      format.html
      format.js
    end

    @purchase = PurchaseHistory.new
    @product = Product.find(params[:product_id]).decorate
  end

  def create
    @purchase = PurchaseHistory.new(purchase_params.merge(customer_id: current_customer.id))
    head :ok if @purchase.save
  end

  def destroy
    puts current_customer.id
    puts @product.id
    puts '='*40
    puts PurchaseHistory.where(customer_id: current_customer.id, product_id: @product.id).limit(1).destroy_all
    puts '='*40
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def purchase_params
    params.require(:purchase_history).permit(:created_at, :product_id)
  end
end
