class Api::V1::ItemsController < ApplicationController
  before_action :get_item, only: [:show]
  
  def index
    render json: ItemSerializer.items_index(Item.all)
  end

  def show
    render json: ItemSerializer.item_show(@item)
  end

  def create
    item = Item.new(item_params)

    if item.save
      render json: ItemSerializer.item_show(item)
    else
      render json: ErrorSerializer.creation_errors(item), status: 422
    end
  end

  private

  def get_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
