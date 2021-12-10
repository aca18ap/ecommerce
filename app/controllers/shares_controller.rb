class SharesController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    share = Share.find_by(feature: params[:feature], social: params[:social])
    if share
      share.update(count: share.count + 1)
    else
      Share.new(feature: params[:feature], social: params[:social], count: 1)
    end
  end
end
