class Api::V1::RevenueController::RevenueSerializer
  def self.total_revenue(revenue)
    {
      data: {
        id: nil,
        attributes: {
          revenue: revenue
        }
      }
    }
  end
end
