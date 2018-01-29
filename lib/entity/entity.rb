class Entity
  #
  # Assumptions:
  #   - documents in each entity have uniform json schema
  #

  @@data = nil

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
  def self.load force=false
  end

end
