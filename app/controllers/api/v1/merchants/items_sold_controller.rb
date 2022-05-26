class Api::V1::Merchants::ItemsSoldController < ApplicationController
  def index
    if params[:quantity].to_i < 1
      render json: {error: 'quantities under 1 are not allowed'}, status: 400
    elsif params[:quantity].nil?
      merchants = Merchant.find_top_merchants_by_items_sold
      render json: Api::V1::MerchantItemsController::MerchantItemsSoldSerializer.merchant_items_sold_index(merchants)
    else
      merchants = Merchant.find_top_merchants_by_items_sold(params[:quantity])
      render json: Api::V1::MerchantItemsController::MerchantItemsSoldSerializer.merchant_items_sold_index(merchants)
    end
  end
end
