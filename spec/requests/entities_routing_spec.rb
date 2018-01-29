require "rails_helper"

RSpec.describe V1::EntitiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/entities").to route_to("v1/entities#index")
    end

    it "routes to #fields" do
      expect(:get => "/entities/1/fields").to route_to("v1/entities#fields", id: "1")
    end

  end
end
