class FaqsController < ApplicationController
  before_action :set_faq, only: [:show, :edit, :answer, :update, :destroy]

  # GET /faqs
  def index
    @faqs = Faq.order(clicks: :desc)
  end

  # GET /faqs/1
  def show
    @faq.clicks = @faq.clicks + 1
    @faq.save
  end

  # GET /faqs/new
  def new
    @faq = Faq.new
  end

  # GET /faqs/1/edit
  def edit
  end

  # GET /faqs/1/answer
  def answer
  end

  # POST /faqs
  def create
    @faq = Faq.new(faq_params)

    if @faq.save
      redirect_to @faq, notice: 'Question was successfully submitted.'
    else
      render :new
    end
  end

  # PATCH/PUT /faqs/1
  def update
    if @faq.update(faq_params)
      redirect_to @faq, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /faqs/1
  def destroy
    @faq.destroy
    redirect_to faqs_url, notice: 'Question was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faq
      @faq = Faq.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def faq_params
      params.require(:faq).permit(:question, :answer, :clicks, :hidden, :usefulness)
    end
end