class V1::SearchController < ApplicationController

  # TODO: use an api documentation generator
  #
  # params:
  #   - q : word to search (required)
  #   - e : perform search within the data of an entity, such as ticket, user, etc.
  #   - f : perform search within a field, such as name, email, tags, subject, description, etc.
  #
  def index
    render json: { id: 1, name: "Mohammad Khan" }
  end
end
