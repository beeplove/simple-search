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

  def perform_search query, opts={}
    # wordify chunk: "hiking"=>{"person"=>{"activities"=>[["1", "1"]]}, "store"=>{"tags"=>[["2", "2"]]}}
    query = query.to_s

    entity_names = opts[:entity_names]
    entity_names = @entity.list.values if entity_names.blank?

    fields = opts[:fields] || []

    duplicate_check = {}
    result = {}

    entity_names.each do |entity_name|                            # "person"
      next unless @wordify.get(query) && @wordify.get(query)[entity_name]

      result[entity_name] = [] unless result[entity_name]
      duplicate_check[entity_name] = {} unless duplicate_check[entity_name]

      @wordify.get(query)[entity_name].each do |key, values|     # "activities"=>[["1", "1"]]
        next if fields.present? && !fields.include?(key)

        values.each do |value|                                    # ["1", "1"]
          unless duplicate_check[entity_name][value[0]]
            result[entity_name] << @entity.data[entity_name][value[0]]
            duplicate_check[entity_name][value[0]] = true
          end
        end
      end
    end

    result
  end

  def build_opts_from params
    opts = {}
    opts[:entity_names] = [params[:e]] if params[:e].present?
    opts[:fields]       = [params[:f]] if params[:f].present?

    opts
  end
end
