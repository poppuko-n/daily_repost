require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/users/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/users/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /follow" do
    it "returns http success" do
      get "/users/follow"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /unfollow" do
    it "returns http success" do
      get "/users/unfollow"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /followers" do
    it "returns http success" do
      get "/users/followers"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /following" do
    it "returns http success" do
      get "/users/following"
      expect(response).to have_http_status(:success)
    end
  end

end
