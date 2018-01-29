class V1::EntitiesController < ApplicationController

  # GET /entities
  def index
    @entities = ::Entity.list
    jsonator @entities
  end

  # GET /entities/:id/fields
  def fields
  end
end
