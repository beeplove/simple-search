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
    raise EntityError, "db_path doen't exist" unless Dir.exists?(config["db_path"])

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
    if @@data.nil?
      # For warming up @@data
      entity = Entity.new(config)
      entity.load
    end

    entity_name = @@list[entity_id.to_s]
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
  # {"person"=>{"1"=>{"_id"=>1, "name"=>"Mohammad Khan"}}}
  def load force=false
    id = 1
    data_hash = nil
    list_hash = nil

    Dir.entries(@db_path).sort.each do |filename|
      filepath = @db_path + "/" + filename

      next unless File.file?(filepath)
      file = File.read(filepath)

      name = filename.sub(/\.json$/i, '')

      data_hash = {} if data_hash.nil?
      list_hash = {} if list_hash.nil?

      data_hash[name.to_s] = {}
      JSON.parse(file).each do |item|
        data_hash[name.to_s][item["_id"].to_s] = item
      end

      list_hash[id.to_s] = name.to_s
      id = id + 1
    end

    @@data = data_hash
    @@list = list_hash
  end

end
