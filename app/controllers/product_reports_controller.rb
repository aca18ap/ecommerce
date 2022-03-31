class ProductReportsController < ApplicationController
  before_action :set_product_report, only: [:show, :destroy]
  authorize_resource

  # GET /product_reports
  def index
    @product_reports = ProductReport.accessible_by(current_ability).decorate
  end

  # GET /product_reports/1
  def show
    @product_report = @product_report.decorate
  end

  # GET /product_reports/new
  def new
    if params[:product_id]
      @product_report = ProductReport.new
      @product_report.product = Product.find(params[:product_id]).decorate if params[:product_id]
    else
      redirect_to products_url, notice: 'You must select a product to report.'
    end
  end

  # POST /product_reports
  def create
    @product_report = ProductReport.new(
      product_id: product_report_params[:product_id],
      customer_id: current_customer.id,
      content: product_report_params[:content]
    )

    if @product_report.save
      redirect_to products_url, notice: 'Thank you for submitting a report. This will be reviewed soon.'
    else
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
end
