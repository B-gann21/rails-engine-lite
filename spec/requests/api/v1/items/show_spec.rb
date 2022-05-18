require 'rails_helper'

RSpec.describe 'Items Show Endpoint' do
  context 'when a valid id is given' do
    before :each do
      merchant = create(:merchant) do |merchant|
        create(:item, merchant: merchant)
      end

      get "/api/v1/items/#{merchant.items.first.id}"

      full_response = JSON.parse(response.body, symbolize_names: true)

      @item = full_response[:data]
    end

    it 'returns a JSON hash with data on the item' do
      expect(@item).to have_key :id
      expect(@item[:id]).to be_a String

      expect(@item).to have_key :type
      expect(@item[:type]).to eq('item')

      expect(@item).to have_key :attributes
      expect(@item[:attributes]).to be_a Hash

      expect(@item[:attributes]).to have_key :name
      expect(@item[:attributes][:name]).to be_a String

      expect(@item[:attributes]).to have_key :description
      expect(@item[:attributes][:description]).to be_a String

      expect(@item[:attributes]).to have_key :unit_price
      expect(@item[:attributes][:unit_price]).to be_a Float

      expect(@item[:attributes]).to have_key :merchant_id
      expect(@item[:attributes][:merchant_id]).to be_a Integer
    end
  end

  context 'when an invalid id is given' do
    before :each do
      merchant = create(:merchant)
      @item = create(:item, merchant: merchant)

      get "/api/v1/items/#{@item.id - 1}"
    end

    it 'returns status code 404' do
      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
    end

    it 'returns an error instead of a data object' do
      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body).to have_key :message
      expect(response_body[:message]).to eq('your query could not be completed')

      expect(response_body).to have_key :errors
      expect(response_body[:errors]).to be_a Array
      expect(response_body[:errors]).to be_all String
      expect(response_body[:errors][0]).to eq("no item found with an ID of #{@item.id - 1}")
    end
  end
end
