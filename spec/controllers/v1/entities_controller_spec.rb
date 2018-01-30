require 'rails_helper'

RSpec.describe V1::EntitiesController, type: :controller do

  describe "GET #index" do
    it "returns list of available entities" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
    end
  end

  describe "GET #fields" do
    it "returns list of available fields in an entity" do
      get :fields, params: { id: 1 }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
    end

    it "returns error when entity id doesn't exist in database" do
      get :fields, params: { id: 104 }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json')
    end
  end
end
