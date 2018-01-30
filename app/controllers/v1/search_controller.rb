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
    raise QueryParamError, "q param is required to perform a search" if params[:q].blank?
    jsonator perform_search(params[:q], build_opts_from(params))
  end

end
