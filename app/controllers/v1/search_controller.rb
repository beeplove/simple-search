class V1::SearchController < ApplicationController
  include SearchConcern

  # TODO: use an api documentation generator
  #
  # params:
  #   - q : word to search (required)
  #   - e : perform search within the data of an entity, such as ticket, user, etc.
  #   - f : perform search within a field, such as name, email, tags, subject, description, etc.
  #
  # GET /search
  def index
    jsonator search_result(params[:q])
  end

end
