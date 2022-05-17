class Api::V1::MerchantsController::MerchantSerializer
  def self.merchants_index(merchants)
    {
      data: merchants.map do |merchant|
        {
          id: merchant.id,
          type: 'merchant',
          attributes: {
            name: merchant.name,
          }
        }
      end
    }
  end

  def self.merchant_show(merchant)
    {
      data: {
        id: merchant.id.to_s,
        type: 'merchant',
        attributes: {
          name: merchant.name,
        }
      }
    }
  end
end
