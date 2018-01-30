class V1::EntitiesController < ApplicationController

  # GET /entities
  def index
    entity = Entity.new CONFIG["entity"]
    jsonator entity.list
  end

  # GET /entities/:id/fields
  def fields
    jsonator Entity.fields_for(params[:id], CONFIG["entity"])
  end
end
