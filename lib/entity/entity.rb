require 'json'

class Entity
  #
  # Assumptions:
  #   - documents in each entity have uniform json schema
  #

  @@data = nil
  @@list = nil

  #
  # Entity.list returns a list of entity available in the database
  #
  def self.list
    [
      {
        id: 1,
        name: 'organizations'
      },
      {
        id: 2,
        name: 'tickets'
      },
      {
        id: 3,
        name: 'users'
      }
    ]
  end

  #
  # Entity.fields take either id or name as param
  # to return list of available fields in the entity
  #
  def self.fields entity
    Entity.load if @@data.nil?

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
  def self.load force=false
    # TODO: Move dirname to a config
    dirname = "#{Dir.pwd}/lib/entity/db"

    @@data = {}
    @@list = []
    id = 0

    Dir.entries(dirname).sort.each do |filename|
      filepath = dirname + "/" + filename

      next unless File.file?(filepath)
      file = File.read(filepath)

      name = filename.sub(/\.json$/i, '')
      id = id + 1

      @@data["id"] = JSON.parse(file)
      @@list << { id: id, name: name }
    end
  end

end
