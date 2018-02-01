class Wordify
  @@data = nil

  #
  # load takes data as param and return hash by keeping input hash's value as key
  #
  # param example:
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
  # return example:
  # {
  #   "1"=>{"person"=>{"_id"=>[["1"]]}, "store"=>{"_id"=>[["1"]]}},
  #   "MOHAMMAD KHAN"=>{"person"=>{"name"=>[["1"]]}},
  #   "RUNNING"=>{"person"=>{"activities"=>[["1", "0"], ["2", "1"]]}, "store"=>{"tags"=>[["2", "1"]]}},
  #   "HIKING"=>{"person"=>{"activities"=>[["1", "1"]]}, "store"=>{"tags"=>[["2", "2"]]}},
  #   "SWIMMING"=>{"person"=>{"wishlist"=>[["1", "0"]], "activities"=>[["2", "0"]]}, "store"=>{"tags"=>[["2", "3"]]}},
  #   "2"=>{"person"=>{"_id"=>[["2"]]}, "store"=>{"_id"=>[["2"]]}},
  #   "JOHN SMITH"=>{"person"=>{"name"=>[["2"]]}},
  #   "PUBLIX"=>{"store"=>{"name"=>[["1"]], "tags"=>[["1", "2"]]}},
  #   "GROCERY"=>{"store"=>{"tags"=>[["1", "0"]]}},
  #   "HEALTH"=>{"store"=>{"tags"=>[["1", "1"]]}},
  #   "REI"=>{"store"=>{"name"=>[["2"]]}},
  #   "CAMPING"=>{"store"=>{"tags"=>[["2", "0"]]}}
  # }
  #
  def load data_repo
    return unless data_repo.instance_of? Hash

    @@data = {}

    data_repo.each do |entity_name, entity_data|                      # ticket/user
      entity_data.each do |item_key, item|                            # 1/2/3 (value of _id key)
        item.each do |key, value|                                     # id/email/tags
          constuct_and_add_to_data(value, entity_name, item_key, key)
        end
      end
    end

    @@data
  end

  def data
    @@data
  end

  #
  # Assumption: document in entity doesn't have deep nested objects
  # TODO: if above assumption is wrong, construct @@data recursively.
  #
  def constuct_and_add_to_data value, entity_name, item_key, key
    return if value.blank?

    if (value.instance_of? String) || (value.kind_of? Numeric)
      add_to_data(value.to_s, entity_name, item_key, key)
    elsif value.instance_of? Array
      value.each_with_index do |v, i|
        add_to_data(v.to_s, entity_name,item_key, key, i.to_s)
      end
    end
  end
  private :constuct_and_add_to_data

  #
  # take the value, convert to uppercase and use it as key, so that
  # search can be performed in case-insensitive manner
  # 
  # params:
  #   - value: last node
  #   - entity_name: such as organizations, tickets, users
  #   - item_key: value of _id in document of entity
  #   - key: each attribute/field in the document such as tags, email, name
  #
  def add_to_data value, entity_name, item_key, key, idx=nil
    # arr = [_id of document in entity, index of value in key if it's an array]
    arr = [item_key]

    # TODO: No usage of index of value when it's in an array, so far.
    arr << idx unless idx.nil?

    value.split.each do |word|
      word = word.upcase

      @@data[word]                    = {} if @@data[word].nil?
      @@data[word][entity_name]       = {} if @@data[word][entity_name].nil?
      @@data[word][entity_name][key]  = [] if @@data[word][entity_name][key].nil?

      @@data[word][entity_name][key] << arr
    end
    # value = value.upcase
    # @@data[value] = {} if @@data[value].nil?
    # @@data[value][entity_name] = {} if @@data[value][entity_name].nil?

    # @@data[value][entity_name][key] = [] if @@data[value][entity_name][key].nil?

    # @@data[value][entity_name][key] << arr
  end
  private :add_to_data

  #
  # get the object from @@data for value (case-insensitive)
  #
  def get value
    return if @@data.nil?

    @@data[value.upcase]
  end
end
