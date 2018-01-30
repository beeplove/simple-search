require 'rails_helper'

RSpec.describe V1::SearchController, type: :controller do
  describe "GET #index" do
    it "takes q for query, as an required param" do
      get :index, params: { q: "John Smith" }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
    end

    it "takes e for entity, as an optional param"
    it "takes f for field, as an optional param"
  end
end
