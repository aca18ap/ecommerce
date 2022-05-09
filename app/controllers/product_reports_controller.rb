# frozen_string_literal: true

# Product Reports Controller handles creation and deletion requests of user reports of products
class ProductReportsController < ApplicationController
  before_action :set_product_report, only: %i[show destroy]
  before_action :authenticate_staff!, except: %i[new create show created]
  authorize_resource

  # GET /product_reports
  def index
    @product_reports = ProductReport.includes([:staff,:business]).accessible_by(current_ability).decorate
  end

  # GET /product_reports/1
  def show
    @product_report = @product_report.decorate
  end

  # GET /product_reports/new
  def new
    if params[:product_id]
      @product_report = ProductReport.new
      @product_report.product = Product.find(params[:product_id]).decorate
    else
      redirect_to products_url, notice: 'You must select a product to report.'
    end
  end

  # POST /product_reports
  def create
    @product_report = ProductReport.new(
      product_id: product_report_params[:product_id],
      content: product_report_params[:content]
    )

    assign_user(@product_report)

    if @product_report.save
      redirect_to products_url, notice: 'Thank you for submitting a report. This will be reviewed soon.'
    else
      @product_report.product = Product.find(product_report_params[:product_id]).decorate
      render :new
    end
  end

  # DELETE /product_reports/1
  def destroy
    @product_report.destroy
    redirect_to product_reports_url, notice: 'Product report was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product_report
    @product_report = ProductReport.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def product_report_params
    params.require(:product_report).permit(:product_id, :content)
  end

  def assign_user(_product_report)
    if current_staff
      @product_report.staff_id = current_staff.id
    elsif current_business
      @product_report.business_id = current_business.id
    elsif current_customer
      @product_report.customer_id = current_customer.id
    end
  end
end
