require 'entity/entity'
require 'wordify/wordify'

module SearchConcern
  extend ActiveSupport::Concern

  included do
    before_action :warm_up_data, only: [:index]
  end

  def warm_up_data
    @entity = Entity.new(CONFIG["entity"]) if @entity.nil?
    @wordify = Wordify.new
    @wordify.load(@entity.data)
  end

  def perform_search query
    # wordify chunk: "hiking"=>{"person"=>{"activities"=>[["1", "1"]]}, "store"=>{"tags"=>[["2", "2"]]}}

    result = {}
    entity_names = @entity.list.values

    entity_names.each do |entity_name|                            # "person"
      next unless @wordify.data[query] && @wordify.data[query][entity_name]

      result[entity_name] = [] unless result[entity_name]

      @wordify.data[query][entity_name].each do |key, values|     # "activities"=>[["1", "1"]]
        values.each do |value|                                    # ["1", "1"]
          result[entity_name] << @entity.data[entity_name][value[0]]
        end
      end
    end

    result
  end
end
