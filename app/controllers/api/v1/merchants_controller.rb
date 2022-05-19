class Api::V1::MerchantsController < ApplicationController
  include RecordNotFoundHelper
  rescue_from ::ActiveRecord::RecordNotFound, with: :merchant_not_found

  before_action :get_merchant, only: [:show]

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
end
