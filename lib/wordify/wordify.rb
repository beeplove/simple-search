class Wordify
  @@data = nil

  #
  # load takes data as param and return hash by keeping input hash's value as key
  #
  # param example:
  # {
  #   "person"=>{
  #     "1"=>{"_id"=>1, "name"=>"Mohammad Khan", "activities"=>["running", "hiking"]},
  #     "2"=>{"_id"=>2, "name"=>"John Smith", "activities"=>["swimming", "running"]}
  #   },
  #   "store"=>{
  #     "1"=>{"_id"=>1, "name"=>"publix", "tags"=>["grocery", "health"]},
  #     "2"=>{"_id"=>2, "name"=>"rei", "tags"=>["camping", "running", "hiking", "swimming"]}
  #   }
  # }
  #
  # return example:
  # {
  #   "1"=>{"person"=>[["1", "_id"]], "store"=>[["1", "_id"]]},
  #   "Mohammad Khan"=>{"person"=>[["1", "name"]]},
  #   "running"=>{"person"=>[["1", "activities", "0"], ["2", "activities", "1"]], "store"=>[["2", "tags", "1"]]},
  #   "hiking"=>{"person"=>[["1", "activities", "1"]], "store"=>[["2", "tags", "2"]]},
  #   "2"=>{"person"=>[["2", "_id"]], "store"=>[["2", "_id"]]},
  #   "John Smith"=>{"person"=>[["2", "name"]]},
  #   "swimming"=>{"person"=>[["2", "activities", "0"]], "store"=>[["2", "tags", "3"]]},
  #   "publix"=>{"store"=>[["1", "name"]]},
  #   "grocery"=>{"store"=>[["1", "tags", "0"]]},
  #   "health"=>{"store"=>[["1", "tags", "1"]]},
  #   "rei"=>{"store"=>[["2", "name"]]},
  #   "camping"=>{"store"=>[["2", "tags", "0"]]}
  # }
  #
  def load full_entity_data
    @@data = {}

    full_entity_data.each do |entity_name, entity_data|               # ticket/user
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

  def constuct_and_add_to_data value, entity_name, item_key, key
    return if value.blank?

    if (value.kind_of? String) || (value.kind_of? Numeric)
      add_to_data(value.to_s, entity_name, item_key, key)
    elsif value.kind_of? Array
      value.each_with_index do |v, i|
        add_to_data(v.to_s, entity_name,item_key, key, i.to_s)
      end
    end
  end
  private :constuct_and_add_to_data

  def add_to_data value, entity_name, item_key, key, idx=nil
      arr = [item_key]
      arr << idx unless idx.nil?
      # arr = [_id of document in entity, index of value in key if it's an array]

      @@data[value] = {} if @@data[value].nil?
      @@data[value][entity_name] = {} if @@data[value][entity_name].nil?

      @@data[value][entity_name][key] = [] if @@data[value][entity_name][key].nil?

      @@data[value][entity_name][key] << arr
  end
  private :add_to_data
end
