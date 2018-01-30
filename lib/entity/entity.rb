require 'json'
require 'entity/error'

class Entity
  #
  # Assumptions:
  #   - documents in each entity have uniform json schema
  #   - each document has _id key
  #

  @@data = nil
  @@list = nil

  def initialize config={}
    raise EntityError, "need config with db_path to initialize Entity" unless config["db_path"]
    raise EntityError, "db_path provided in the config doen't exist as directory" unless Dir.exists?(config["db_path"])

    @db_path = config["db_path"]
  end

  #
  # list returns a list of entity available in the database
  #
  def list
    load if @@list.nil?

    @@list
  end

  def data
    load if @@data.nil?

    @@data
  end

  #
  # Entity.fields_for take entity_id as a param
  # to return list of available fields in the entity
  #
  def Entity.fields_for entity_id, config={}
    # For warming up @@data
    if @@data.nil?
      entity = Entity.new(config)
      entity.load
    end

    entity_name = @@list[entity_id.to_s]
    raise EntityError, "entity id doesn't exist in database" if entity_name.blank?

    @@data[entity_name][@@data[entity_name].keys.first].keys
  end

  #
  # Load json data from db/ folder to @@data
  #
  # TODO:
  #   - check @@data, @@list
  #   - take force into account
  #
  # returns data in the following format
  # {
  #   "person"=>{
  #     "1"=>{"_id"=>1, "name"=>"Mohammad Khan", "activities"=>["running", "hiking"], "wishlist"=>["swimming"]},
  #     "2"=>{"_id"=>2, "name"=>"John Smith", "activities"=>["swimming", "running"], "wishlist"=>[]}
  #   },
  #   "store"=>{
  #     "1"=>{"_id"=>1, "name"=>"publix", "tags"=>["grocery", "health", "publix"]},
  #     "2"=>{"_id"=>2, "name"=>"rei", "tags"=>["camping", "running", "hiking", "swimming"]}
  #   }
  # }
  #
  def load force=false
    return self unless @@data.blank? && @@list.blank?

    id = 1
    data_hash = {}
    list_hash = {}

    Dir.entries(@db_path).sort.each do |filename|
      filepath    = @db_path + "/" + filename
      next unless File.file?(filepath)

      file        = File.read(filepath)
      entity_name = filename.sub(/\.json$/i, '').to_s

      data_hash[entity_name] = {}
      JSON.parse(file).each do |item|
        data_hash[entity_name][item["_id"].to_s] = item
      end

      list_hash[id.to_s] = entity_name
      id = id + 1
    end

    @@data = data_hash
    @@list = list_hash

    self
  end

end
