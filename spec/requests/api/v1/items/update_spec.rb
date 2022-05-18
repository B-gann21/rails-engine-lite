require 'rails_helper'

RSpec.describe 'Updating an Item' do
  before :each do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    @item_params = {
      name: 'Billy Jonson',
      unit_price: 30
    }

    patch "/api/v1/items/#{item.id}", params: @item_params

    full_response = JSON.parse(response.body, symbolize_names: true)

    @item = Item.find(item.id)
    @item_response = full_response[:data]
  end

  context 'when valid data is entered' do
    it 'returns a JSON hash with item details' do
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
      expect(@item_response[:attributes][:description]).to eq(@item.description)

      expect(@item_response[:attributes]).to have_key :unit_price
      expect(@item_response[:attributes][:unit_price]).to eq(@item_params[:unit_price])

      expect(@item_response[:attributes]).to have_key :merchant_id
      expect(@item_response[:attributes][:merchant_id]).to eq(@item.merchant_id)
    end

    it 'updates the item' do
      expect(@item.name).to eq(@item_params[:name])
      expect(@item.unit_price).to eq(@item_params[:unit_price])
    end
  end

  context 'when invalid data is entered' do
    it 'returns an error if any attributes fail validation' do
      @item_params[:unit_price] = Faker::Food.dish

      patch "/api/v1/items/#{@item.id}", params: @item_params

      full_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)

      expect(full_response).to have_key :message
      expect(full_response[:message]).to eq('your query could not be completed')

      expect(full_response).to have_key :errors
      expect(full_response[:errors]).to be_a Array
      expect(full_response[:errors]).to be_all String
      expect(full_response[:errors].count).to eq 1
      expect(full_response[:errors][0]).to eq 'Unit price is not a number'
    end 

    it 'does not update the item' do
      item_params = {
        unit_price: Faker::Food.dish
      }

      patch "/api/v1/items/#{@item.id}", params: item_params
      
      expect(@item.unit_price).to_not eq(item_params[:unit_price])
    end

    it 'ignores any attributes that are not allowed' do
      @item_params[:food] = Faker::Food.dish
      @item_params[:hacker_encryption] = Faker::String.random

      patch "/api/v1/items/#{@item.id}", params: @item_params

      expect(response).to be_successful

      expect(@item).to_not respond_to(:food)
      expect(@item_response).to_not have_key(:food)

      expect(@item).to_not respond_to(:hacker_encryption)
      expect(@item_response).to_not have_key(:hacker_encryption)
    end
  end
end
