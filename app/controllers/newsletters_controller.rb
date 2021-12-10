# frozen_string_literal: true

class NewslettersController < ApplicationController
  authorize_resource
  before_action :set_newsletter, only: [:show, :edit, :update, :destroy]

  # GET /newsletters
  def index
    @newsletters = Newsletter.all
  end

  # GET /newsletters/1
  def show; end

  # GET /newsletters/new
  def new
    @newsletter = Newsletter.new
  end

  # GET /newsletters/1/edit
  def edit; end

  # POST /newsletters
  def create

    location = RetrieveLocation.new(newsletter_params, request.remote_ip).get_location

    @newsletter = Newsletter.new(
      email: newsletter_params['email'],
      vocation: newsletter_params['vocation'],
      longitude: location['longitude'],
      latitude: location['latitude']
    )

    # Check if user adding newsletter is admin
    if @newsletter.save
      if !user_signed_in?
        redirect_to '/thanks'
      else
        redirect_to @newsletter, notice: 'Newsletter was successfully created.'
      end
    else
      render :new
    end
  end

  # PATCH/PUT /newsletters/1
  def update
    if @newsletter.update(newsletter_params)
      redirect_to @newsletter, notice: 'Newsletter was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /newsletters/1
  def destroy
    @newsletter.destroy
    redirect_to newsletters_url, notice: 'Newsletter was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_newsletter
    @newsletter = Newsletter.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def newsletter_params
    params.require(:newsletter).permit(:email, :vocation, :tier, :latitude, :longitude)
  end

end
