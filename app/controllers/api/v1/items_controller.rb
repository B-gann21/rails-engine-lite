class Api::V1::ItemsController < ApplicationController
  before_action :get_item, only: [:show]
  
  def index
    render json: ItemSerializer.items_index(Item.all)
  end

  def show
    render json: ItemSerializer.item_show(@item)
  end

  def get_item
    @item = Item.find(params[:id])
  end
end
