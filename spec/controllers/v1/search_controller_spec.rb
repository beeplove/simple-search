require 'rails_helper'

RSpec.describe V1::SearchController, type: :controller do
  describe "GET #index" do
    it "takes q for query, as an required param" do
      get :index, params: { q: "John Smith" }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
    end

    it "takes e for entity, as an optional param" do
      get :index, params: { q: "John Smith", e: "person" }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
    end


    it "takes f for field, as an optional param" do
      get :index, params: { q: "hiking", f: "tags" }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
    end

    it "returns error if param q is not provided" do
      get :index

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json')
    end
  end
end
