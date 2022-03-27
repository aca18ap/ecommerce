class ProductReportsController < ApplicationController
  before_action :set_product_report, only: [:show, :edit, :update, :destroy]

  # GET /product_reports
  def index
    @product_reports = ProductReport.all.decorate
  end

  # GET /product_reports/1
  def show
  end

  # GET /product_reports/new
  def new
    @product_report = ProductReport.new
  end

  # POST /product_reports
  def create
    @product_report = ProductReport.new(
      product_id: product_report_params[:product_id],
      customer_id: current_customer.id,
      content: product_report_params[:content]
    )

    if @product_report.save
      redirect_to @product_report, notice: 'Product report was successfully created.'
    else
      puts product_report_params
      puts "==================================="
      puts current_customer.id
      puts @product_report.errors.full_messages
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
      @product_report = ProductReport.find(params[:id]).decorate
    end

    # Only allow a list of trusted parameters through.
    def product_report_params
      params.require(:product_report).permit(:product_id, :content)
    end
end
