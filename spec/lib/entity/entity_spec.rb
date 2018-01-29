require 'entity/entity'


RSpec.describe Entity do
  let(:config) { CONFIG["entity"] }

  describe "#list" do
    it "returns list of entities avaiable" do
      entity = Entity.new(config)
      expect(entity.list).to eq(Entity.class_variable_get :@@list)
    end
  end

  describe "#fields" do
    it "returns list of fields avaiable for a given entity name"
  end

  describe "#data" do
    it "returns data avaiable for a given entity name"
  end

  describe ".load" do
    it "loads all data from database" do
      entity = Entity.new(config)
      entity.load
      expect(Entity.class_variable_get :@@data).not_to be_nil
    end
  end
end
