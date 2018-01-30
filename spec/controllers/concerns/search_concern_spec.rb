require 'rails_helper'

class SearchConcernController < ApplicationController
  include SearchConcern
end
 
describe SearchConcernController, type: :controller do
  let(:concern) { SearchConcernController.new }

  describe "#perform_search" do
    it "does't contain duplicate document"

    context "when only query is provided" do
      let(:result) {
        concern.warm_up_data
        concern.perform_search("hiking")
      }

      it "returns all documents among all entity and fields" do
        person = result["person"][0]
        store = result["store"][0]
        expect(person["_id"]).to eq(1)
        expect(store["_id"]).to eq(2)
      end
    end

    context "when query and entity_names are provided"
    context "when query, entity_names and fields are provided"
    context "when query and fields are provided"
  end
end
