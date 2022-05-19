class Api::V1::MerchantsController::MerchantSerializer
  def self.merchants_index(merchants)
    {
      data: merchants.map do |merchant|
        {
          id: merchant.id.to_s,
          type: 'merchant',
          attributes: {
            name: merchant.name,
          }
        }
      end
    }
  end

  def self.merchant_show(merchant)
    if merchant
      {
        data: {
          id: merchant.id.to_s,
          type: 'merchant',
          attributes: {
            name: merchant.name,
          }
        }
      }
    else
      {
        data: {}
      }
    end
  end
end
