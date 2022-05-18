class Api::V1::ItemsController < ApplicationController
  before_action :get_item, only: [:show, :update, :destroy]
  rescue_from ::ActiveRecord::RecordNotFound, with: :item_not_found
  
  def index
    render json: ItemSerializer.items_index(Item.all)
  end

  def show
    render json: ItemSerializer.item_show(@item)
  end

  def create
    item = Item.new(item_params)

    if item.save
      render json: ItemSerializer.item_show(item), status: 201
    else
      render json: ItemErrorSerializer.creation_errors(item), status: 422
    end
  end

  def update
    if @item.update(item_params)
      render json: ItemSerializer.item_show(@item), status: 201
    else
      render json: ItemErrorSerializer.creation_errors(@item), status: 404
    end
  end

  def destroy
    render json: Item.destroy(params[:id]), status: 204
  end

  private

  def get_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end

  def item_not_found
    render json: ItemErrorSerializer.no_item(params[:id]), status: 404
  end
end
