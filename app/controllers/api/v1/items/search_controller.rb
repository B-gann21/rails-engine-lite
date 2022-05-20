class Api::V1::Items::SearchController < ApplicationController
  def show
    if params[:name] && (params[:max_price] || params[:min_price])
      render json: Api::V1::ItemsController::ItemErrorSerializer.invalid_search, status: 404

    elsif params[:name] && (!params[:max_price] && !params[:min_price])
      item = Item.find_first_by_name(params[:name])
      render json: Api::V1::ItemsController::ItemSerializer.item_show(item)

    elsif params[:max_price] && params[:min_price]
      item = Item.find_first_by_price_range(params[:min_price], params[:max_price]) 
      render json: Api::V1::ItemsController::ItemSerializer.item_show(item)

    elsif params[:min_price] && !params[:min_price]
      item = Item.find_first_by_min_price(params[:min_price])
      render json: Api::V1::ItemsController::ItemSerializer.item_show(item)

    elsif !params[:min_price] && params[:max_price]
      item = Item.find_first_by_max_price(params[:max_price])
      render json: Api::V1::ItemsController::ItemSerializer.item_show(item)
    end
  end

  def index
    items = Item.find_all_by_name(params[:name])
    render json: Api::V1::ItemsController::ItemSerializer.items_index(items)
  end
end
