class Api::V1::Items::SearchController < ApplicationController
  def show
    item = Item.find_first_by_params(params)
    
    if item.nil?
      render json: Api::V1::ItemsController::ItemErrorSerializer.invalid_search, status: 404
    else
      render json: Api::V1::ItemsController::ItemSerializer.item_show(item)
    end
  end

  def index
    items = Item.find_all_by_name(params[:name])
    render json: Api::V1::ItemsController::ItemSerializer.items_index(items)
  end
end
