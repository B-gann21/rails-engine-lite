class Api::V1::MerchantItemsController::MerchantItemsSoldSerializer 
  def self.merchant_items_sold_index(merchants)
    {
      data: merchants.map do |merchant|
        {
          id: merchant.id.to_s,
          type: 'items_sold',
          attributes: {
            name: merchant.name,
            count: merchant.count
          }
        }
      end
    }
  end
end
