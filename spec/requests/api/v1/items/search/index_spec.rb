require 'rails_helper'

RSpec.describe 'Endpoint to find all Items' do
  before :each do
    merchant = create(:merchant)
    @item_1 = create(:item, name: 'Turing Handbook', merchant: merchant)
    @item_2 = create(:item, name: 'Ring VHS Tape', merchant: merchant)
    @item_3 = create(:item, name: 'A Guide to Computering', merchant: merchant)
    @item_4 = create(:item, name: 'Diamond', description: 'wedding ring', merchant: merchant)
  end

  context 'when records are found' do
    it 'returns JSON data on all items with names that match' do
      search_params = { name: 'ring' } 

      get '/api/v1/items/find_all', params: search_params

      full_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(full_response).to have_key :data
      expect(full_response[:data]).to be_an Array
      expect(full_response[:data].count).to eq 3

      items_data = full_response[:data]

      items_data.each do |item|
        expect(item).to have_key :id
        expect(item[:id]).to_not eq(@item_4.id.to_s)

        expect(item).to have_key :type
        expect(item[:type]).to eq('item')

        expect(item).to have_key :attributes
        expect(item[:attributes]).to be_a Hash

        expect(item[:attributes]).to have_key :name
        expect(item[:attributes][:name]).to_not eq(@item_4.name)

        expect(item[:attributes]).to have_key :description
        expect(item[:attributes][:description]).to_not eq(@item_4.description)

        expect(item[:attributes]).to have_key :unit_price
        expect(item[:attributes][:unit_price]).to_not eq(@item_4.unit_price)

        expect(item[:attributes]).to have_key :merchant_id
        expect(item[:attributes][:merchant_id]).to be_a Integer
      end
    end
  end

  context 'when records are not found' do
    it 'returns an empty JSON data object' do
      search_params = { name: 'NOMATCHPLEASE' }

      get '/api/v1/items/find_all', params: search_params

      full_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(full_response).to have_key :data
      expect(full_response[:data]).to be_an Array
      expect(full_response[:data]).to be_empty
    end
  end
end
