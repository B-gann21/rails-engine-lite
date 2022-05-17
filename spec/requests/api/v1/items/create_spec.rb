require 'rails_helper'

RSpec.describe 'Creating an Item' do
  before :each do
    create_list(:merchant, 5)

    @item_params = {
      name: 'Tech Deck',
      description: 'Use your fingers to skateboard!',
      unit_price: 15.99,
      merchant_id: Merchant.ids.sample
    }
    post '/api/v1/items', params: @item_params

    full_response = JSON.parse(response.body, symbolize_names: true)

    @item = Item.last
    @item_response = full_response[:data]
  end

  context 'when valid data is entered' do
    it 'returns a JSON response with item details' do
      expect(response).to be_successful
      expect(@item_response).to have_key :id
      expect(@item_response[:id]).to eq(@item.id.to_s)

      expect(@item_response).to have_key :type
      expect(@item_response[:type]).to eq('item')

      expect(@item_response).to have_key :attributes
      expect(@item_response[:attributes]).to be_a Hash

      expect(@item_response[:attributes]).to have_key :name
      expect(@item_response[:attributes][:name]).to eq(@item_params[:name])

      expect(@item_response[:attributes]).to have_key :description
      expect(@item_response[:attributes][:description]).to eq(@item_params[:description])

      expect(@item_response[:attributes]).to have_key :unit_price
      expect(@item_response[:attributes][:unit_price]).to eq(@item_params[:unit_price])

      expect(@item_response[:attributes]).to have_key :merchant_id
      expect(@item_response[:attributes][:merchant_id]).to eq(@item_params[:merchant_id])
    end

    it 'creates an item' do
      expect(@item.name).to eq(@item_params[:name])
      expect(@item.description).to eq(@item_params[:description])
      expect(@item.unit_price).to eq(@item_params[:unit_price])
      expect(@item.merchant_id).to eq(@item_params[:merchant_id])
    end
  end

  context 'when invalid data is entered' do
    it 'returns an error if any attributes are missing' do
      item_params = {
        name: 'Tech Deck'
      }

      post '/api/v1/items', params: item_params 

      full_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status(422)

      expect(full_response).to have_key :message
      expect(full_response[:message]).to eq('your query could not be completed')

      expect(full_response).to have_key :errors
      expect(full_response[:errors]).to be_a Array
      expect(full_response[:errors]).to be_all String
    end
  end
end
