class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.items_index(Item.all)
  end
end
