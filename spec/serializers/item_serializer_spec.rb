require 'rails_helper'

RSpec.describe 'The Items Serializer' do
  context 'class methods' do
    it '.items_show(item) returns empty data response if item is nil' do
      expected = { data: {} } 
      actual = Api::V1::ItemsController::ItemSerializer.item_show(nil)

      expect(actual).to eq(expected)
    end
  end
end
