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
    created_at = Time.parse(purchase_params[:created_at])
    @purchase = PurchaseHistory.new(product_id: purchase_params[:product_id], created_at: created_at,
                                    customer_id: current_customer.id)
    head :ok if @purchase.save
  end

  def destroy
    PurchaseHistory.where(customer_id: current_customer.id, product_id: @product.id).limit(1).destroy_all
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def purchase_params
    params.require(:purchase_history).permit(:created_at, :product_id)
  end
end
