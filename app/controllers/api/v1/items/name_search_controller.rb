class Api::V1::Items::NameSearchController < ApplicationController
  def show
    item = Item.find_first_by_name(params[:name])
    render json: Api::V1::ItemsController::ItemSerializer.item_show(item)
  end
end
