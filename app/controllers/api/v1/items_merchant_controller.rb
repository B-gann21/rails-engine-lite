class Api::V1::ItemsMerchantController < ApplicationController
rescue_from ::ActiveRecord::RecordNotFound, with: :item_not_found

  def index
    @item = Item.find(params[:item_id])

    render json: Api::V1::MerchantsController::MerchantSerializer.merchant_show(@item.merchant)
  end
end
