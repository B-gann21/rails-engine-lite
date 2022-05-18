class Api::V1::MerchantsController < ApplicationController
  before_action :get_merchant, only: [:show]
  rescue_from ::ActiveRecord::RecordNotFound, with: :merchant_not_found

  def index
    render json: MerchantSerializer.merchants_index(Merchant.all)
  end

  def show
    render json: MerchantSerializer.merchant_show(@merchant)
  end

  private

  def get_merchant
    @merchant = Merchant.find(params[:id])
  end

  def merchant_not_found
    render json: MerchantErrorSerializer.no_merchant(params[:id]), status: 404
  end
end
