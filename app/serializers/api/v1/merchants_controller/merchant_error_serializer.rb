class Api::V1::MerchantsController::MerchantErrorSerializer < Api::V1::ApplicationErrorSerializer 
  def self.no_merchant(id)
    base_error_with(["no merchant found with an ID of #{id}"])
  end
end
