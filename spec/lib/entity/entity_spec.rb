require 'entity/entity'

RSpec.describe Entity do
  let(:config) { CONFIG["entity"] }

  describe "#list" do
    it "returns list of entities avaiable" do
      entity = Entity.new(config)
      expect(entity.list["1"] == 'person').to eq(true)
    end
  end

  describe ".fields_for" do
    it "returns list of fields avaiable for a given entity name" do
      fields = Entity.fields_for(1, config)
      expect(fields.include?("name")).to eql(true)
    end
  end

  describe "#data" do
    it "returns data avaiable for a given entity name" do
      entity = Entity.new(config)
      expect(entity.data).not_to eql(nil)
    end
  end
end
