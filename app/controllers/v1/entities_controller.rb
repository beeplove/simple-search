class V1::EntitiesController < ApplicationController

  # GET /entities
  def index
    jsonator Entity.list
  end

  # GET /entities/:id/fields
  def fields
    jsonator Entity.fields(params[:id])
  end
end
