require 'wordify/wordify'

RSpec.describe Wordify do

  let(:entity) { Entity.new(CONFIG["entity"]) }

  describe "#initialize" do
    let(:wordify) { Wordify.new(entity.data) }

    it "generates wordify data by transforming from entity data" do
      expect(wordify.data.nil?).to be_falsy
    end

    it "returns a hash with enough information to pull the document from entity data" do
      expect(wordify.get("hiking").keys.sort).to eq(["person", "store"])
      expect(wordify.get("hiking")["store"]["tags"].first).to eq(["2", "2"])
    end

    it "stores data by word" do
      expect(wordify.get("John").keys.sort).to eq(["person"])
    end

  end
end
