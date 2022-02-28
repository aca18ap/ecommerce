require 'rails_helper'

RSpec.describe "Businesses", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/businesses/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/businesses/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
