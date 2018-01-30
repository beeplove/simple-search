require 'entity/entity'


RSpec.describe Entity do
  let(:config) { CONFIG["entity"] }

  describe ".list" do
    it "returns list of entities avaiable" do
      entity = Entity.new(config)
      expect(entity.list.any?{|item| item[:name] == 'person'}).to eq(true)
    end
  end

  describe "#fields_for" do
    it "returns list of fields avaiable for a given entity name"
  end

  describe "#data" do
    it "returns data avaiable for a given entity name"
  end

  describe ".load" do
    it "loads all data from database" do
      entity = Entity.new(config)
      entity.load
      expect(Entity.class_variable_get :@@data).not_to eq(nil)
    end
  end
end
