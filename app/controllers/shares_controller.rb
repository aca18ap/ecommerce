class SharesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create

    share = Share.where(feature: params[:feature], social: params[:social]).first_or_initialize do |f|
      f.count = 0
    end
    if share.save
      head :ok
    end

    puts("count: ", share.count)
    Share.increment_counter(:count, share.id)
  end

end
