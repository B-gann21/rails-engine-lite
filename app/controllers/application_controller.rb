class ApplicationController < ActionController::API
  def item_not_found
    render json: Api::V1::ItemsController::ItemErrorSerializer.no_item(params[:id]), status: 404
  end

  def merchant_not_found
    if params[:merchant_id]
      render json: Api::V1::MerchantsController::MerchantErrorSerializer.no_merchant(params[:merchant_id]), status: 404
    else
      render json: Api::V1::MerchantsController::MerchantErrorSerializer.no_merchant(params[:id]), status: 404
    end
  end
end
