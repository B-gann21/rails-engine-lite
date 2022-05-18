class Api::V1::ApplicationErrorSerializer
  def self.base_error_with(error_messages)
    {
      message: 'your query could not be completed',
      errors: error_messages
    }
  end
end
