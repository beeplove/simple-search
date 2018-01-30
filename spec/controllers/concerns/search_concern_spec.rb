require 'rails_helper'

class SearchConcernController < ApplicationController
  include SearchConcern
end
 
describe SearchConcernController, type: :controller do
  let(:concern) { SearchConcernController.new }

  describe "#perform_search" do
    before do
      concern.warm_up_data
    end

    context "when only query is provided" do
      it "returns all documents among all entity and fields when search for hiking" do
        result = concern.perform_search("hiking")
        person = result["person"][0]
        store = result["store"][0]

        expect(person["_id"]).to eq(1)
        expect(store["_id"]).to eq(2)
      end

      it "returns all documents among all entity and fields when search for swimming" do
        result = concern.perform_search("swimming")
        people = result["person"]
        stores = result["store"]

        expect(people.size).to eq(2)
        expect(stores.size).to eq(1)
      end

    end

    context "when query and entity_names are provided" do
      let(:result) { concern.perform_search("hiking", entity_names: ["store"]) }

      it "returns only documents match within entity" do
        store = result["store"][0]

        expect(store["_id"]).to eq(2)
        expect(result["person"]).to be(nil)
      end
    end

    context "when query, entity_names and fields are provided" do
      let(:result) { concern.perform_search("running", entity_names: ["person"], fields: ["activities"]) }

      it "returns only documents match within entity and field pair" do
        people = result["person"]

        expect(people.size).to eq(2)
      end
    end

    context "when query and fields are provided" do
      it "returns only documents match within fields provided across all entity" do
        result = concern.perform_search("2", fields: ['_id'])
        people = result["person"]
        stores = result["store"]

        expect(people.size).to eq(1)
        expect(stores.size).to eq(1)
      end
    end

    it "does't contain duplicate document" do
      result = concern.perform_search("publix")
      stores = result["store"]
      expect(stores.size).to eq(1)
    end

    it "does perform search in case-insensitive mode" do
      result = concern.perform_search("HEALTH")
      stores = result["store"]

      expect(stores.size).to eq(1)
    end

    it "does take care of string conversion when perform a search by a number" do
      result = concern.perform_search(1)
      people = result["person"]
      stores = result["store"]

      expect(people.size).to eq(1)
      expect(stores.size).to eq(1)
    end
  end
end
