class FaqsController < ApplicationController
  authorize_resource
  before_action :set_faq, only: [:show, :edit, :answer, :update, :destroy, :like, :dislike]

  # GET /faqs
  def index
    @faqs = Faq.accessible_by(current_ability).order(clicks: :desc)
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

  #POST /faqs/1/like
  def like
    @faq_vote = FaqVote.find_or_create_by(ipAddress: request.remote_ip.to_s, faq_id: @faq.id)
    if @faq_vote.value == 1
      @faq_vote.value = 0
    else
      @faq_vote.value = 1
    end
    if @faq_vote.save
      redirect_to faqs_url, notice: 'Thank you for your feedback!'
    else
      redirect_to faqs_url, notice: 'Sorry, something went wrong.'
    end
  end

  #POST /faqs/1/dislike
  def dislike
    @faq_vote = FaqVote.find_or_create_by(ipAddress: request.remote_ip.to_s, faq_id: @faq.id)
    if @faq_vote.value == -1
      @faq_vote.value = 0
    else
      @faq_vote.value = -1
    end
    if @faq_vote.save
      redirect_to faqs_url, notice: 'Thank you for your feedback!'
    else
      redirect_to faqs_url, notice: 'Sorry, something went wrong.'
    end
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
