class Wordify
  @@data = nil

  #
  # load takes data as param and return hash by keeping input hash's value as key
  #
  # param example:
  # {"person"=> {
  #   "1"=>{"_id"=>1, "name"=>"Mohammad Khan", "activities"=>["running", "hiking"]},
  #   "2"=>{"_id"=>2, "name"=>"John Smith", "activities"=>["swimming", "running"]}
  # }}
  #
  # output example:
  # {
  #   "1"=>[["person", "1", "_id"]],
  #   "Mohammad Khan"=>[["person", "1", "name"]],
  #   "running"=>[["person", "1", "activities", "0"], ["person", "2", "activities", "1"]],
  #   "hiking"=>[["person", "1", "activities", "1"]], "2"=>[["person", "2", "_id"]],
  #   "John Smith"=>[["person", "2", "name"]],
  #   "swimming"=>[["person", "2", "activities", "0"]]
  # }
  #
  def load full_entity_data
    @@data = {}

    full_entity_data.each do |entity_name, entity_data|
      entity_data.each do |item_key, item|
        item.each do |key, value|
          add_to_data(value, key, item_key, entity_name)
        end
      end
    end
  end

  def data
    @@data
  end


  def add_to_data value, key, item_key, entity_name
    return if value.blank?

    if (value.kind_of? String) || (value.kind_of? Numeric)
      value = value.to_s

      @@data[value] = [] if @@data[value].nil?

      # NOTE: For now keeping key references as array,
      # which should be fine for the case where there are only few unique values
      @@data[value] << [entity_name, item_key, key]
    elsif value.kind_of? Array
      value.each_with_index do |v, i|
        @@data[v] = [] if @@data[v].nil?
        @@data[v] << [entity_name, item_key, key, i.to_s]
      end
    end
  end
end
