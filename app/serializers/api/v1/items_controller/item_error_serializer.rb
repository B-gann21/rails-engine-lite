class Api::V1::ItemsController::ItemErrorSerializer < Api::V1::ApplicationErrorSerializer
  def self.creation_errors(item)
    base_error_with(item.errors.full_messages)
  end

  def self.no_item(id)
    base_error_with(["no item found with an ID of #{id}"])
  end
end
