class Api::V1::MerchantsController::MerchantRevenueSerializer
  def self.merchant_revenue_index(merchants)
    {
      data: merchants.map do |merchant|
        {
          id: merchant.id.to_s,
          type: 'merchant_name_revenue',
          attributes: {
            name: merchant.name,
            revenue: merchant.revenue
          } 
        }
      end
    }
  end
end
