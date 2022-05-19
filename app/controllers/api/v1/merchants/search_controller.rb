class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = Merchant.find_first_by_name(params[:name])

    render json: Api::V1::MerchantsController::MerchantSerializer.merchant_show(merchant)
  end
end
