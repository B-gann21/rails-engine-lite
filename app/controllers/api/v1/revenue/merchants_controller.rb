class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    unless params[:quantity].nil?
      merchants = Merchant.find_top_merchants_by_quantity(params[:quantity])

      render json: Api::V1::MerchantsController::MerchantRevenueSerializer.merchant_revenue_index(merchants)
    else
      render json: {error: 'you must include quantity in params'}, status: 400
    end
  end
end
