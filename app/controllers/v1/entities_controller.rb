require 'entity/entity'

class V1::EntitiesController < ApplicationController

  # GET /entities
  def index
    jsonator Entity.new(CONFIG["entity"]).list
  end

  # GET /entities/:id/fields
  def fields
    jsonator Entity.fields_for(params[:id], CONFIG["entity"])
  end
end
