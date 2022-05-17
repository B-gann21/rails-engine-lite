class Api::V1::ItemsController::ItemErrorSerializer
  def self.creation_errors(item)
    {
      message: 'your query could not be completed',
      errors: item.errors.full_messages
    }
  end
end
