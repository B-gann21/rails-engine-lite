require 'rails_helper'

RSpec.describe 'Destroying an Item' do
  before :each do
    @merchant = create(:merchant) do |merchant|
      create_list(:item, 2, merchant: merchant)
    end

    @item_id = @merchant.items.first.id
  end

  context 'when a valid ID is given' do
    it 'destroys the item' do
      expect(@merchant.items.count).to eq 2 

      delete "/api/v1/items/#{@item_id}" 

      expect(response).to be_successful

      expect(@merchant.items.count).to eq 1
    end

    it 'returns status code 204 with no body' do
      delete "/api/v1/items/#{@item_id}"

      expect(response).to have_http_status 204
      expect(response.body).to be_empty
    end
  end

  context 'when an invalid id is given' do
    it 'returns status code 404 with an error message' do
      delete "/api/v1/items/#{@item_id + 20}"

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status 404

      expect(response_body).to have_key :message
      expect(response_body[:message]).to eq 'your query could not be completed'

      expect(response_body).to have_key :errors
      expect(response_body[:errors]).to be_a Array
      expect(response_body[:errors]).to be_all String
      expect(response_body[:errors][0]).to eq("no item found with an ID of #{@item_id + 20}")
    end
  end
end
