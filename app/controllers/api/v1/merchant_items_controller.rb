class Api::V1::MerchantItemsController < Api::V1::MerchantsController
  include RecordNotFoundHelper
  rescue_from ::ActiveRecord::RecordNotFound, with: :merchant_not_found

  def index
    merchant = Merchant.find(params[:merchant_id])

    render json: MerchantItemSerializer.items_index(merchant.items)
  end
end
