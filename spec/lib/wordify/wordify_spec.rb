require 'wordify/wordify'

RSpec.describe Wordify do

  let(:entity_data) {
    entity = Entity.new(CONFIG["entity"])
    entity.data
  }

  describe "#load" do
    let(:wordify) { Wordify.new }

    it "generates wordify data by transforming from entity data" do
      wordify.load(entity_data)
      expect(Wordify.class_variable_get(:@@data).nil?).to be_falsy
    end

    it "returns a hash with enough information to pull the document from entity data" do
      wordify.load(entity_data)
      expect(wordify.data["hiking"].keys.sort).to eq(["person", "store"])
      expect(wordify.data["hiking"]["store"]["tags"].first).to eq(["2", "2"])
    end
  end
end
