# frozen_string_literal: true

# Controller for managing purchases in customer's histories
class PurchaseHistoriesController < ApplicationController
  before_action :set_product
  before_action :authenticate_customer!

  def destroy
    current_customer.products.delete(@product)
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
