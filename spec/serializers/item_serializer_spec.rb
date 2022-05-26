require 'rails_helper'

RSpec.describe 'The Items Serializer' do
  context 'class methods' do
    it '.items_show(item) returns empty data response if item is nil' do
      # test all serializers on the unit level
      # edge case test them by throwing unexpected data

      expected = { data: {} } 
      actual = Api::V1::ItemsController::ItemSerializer.item_show(nil)

      expect(actual).to eq(expected)
    end
  end
end
