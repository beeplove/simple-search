require 'json'
require 'entity/error'

class Entity
  #
  # Assumptions:
  #   - documents in each entity have uniform json schema
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

  #
  # Entity.fields take either id or name as param
  # to return list of available fields in the entity
  #
  def Entity.fields_for entity
    [
      '_id',
      'url',
      'external_urls',
      'name',
      'tags'
    ]
  end

  #
  # Load json data from db/ folder to @@data
  #
  # TODO:
  #   - check @@data, @@list
  #   - take force into account
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
      list_hash = [] if list_hash.nil?

      data_hash["id"] = JSON.parse(file)
      list_hash << { id: id, name: name }
      id = id + 1
    end

    @@data = data_hash
    @@list = list_hash
  end

end
