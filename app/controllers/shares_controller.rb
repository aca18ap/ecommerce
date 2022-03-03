# frozen_string_literal: true

class SharesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @share = Share.new(share_params)
    head :ok if @share.save
  end

  private

  def share_params
    params.require(:share).permit(:feature, :social)
  end
end
