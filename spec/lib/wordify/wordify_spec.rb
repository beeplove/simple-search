require 'wordify/wordify'

RSpec.describe Wordify do

  let(:entity_data) {
    entity = Entity.new(CONFIG["entity"])
    entity.data
  }

  describe "#load" do
    it "generates wordify data by transforming from entity data" do
      wordify = Wordify.new
      wordify.load(entity_data)
      expect(Wordify.class_variable_get(:@@data).nil?).to be_falsy
    end
  end
end
