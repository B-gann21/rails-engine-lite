require 'rails_helper'

RSpec.describe 'Endpoint to find an item by price' do
  before :each do
    merchant = create(:merchant)
    @item_1 = create(:item, name: 'Turing Handbook', unit_price: 50.50, merchant: merchant)
    @item_2 = create(:item, name: 'Ring VHS Tape', unit_price: 60,  merchant: merchant)
    @item_3 = create(:item, name: 'Alpha', unit_price: 50.01, merchant: merchant)
    @item_4 = create(:item, name: 'Something Special', unit_price: 75, merchant: merchant)
  end

  context 'searching by min_price, when a record is found' do
    before :each do
      search_params = { min_price: 50.25 }

      get '/api/v1/items/find', params: search_params

      @full_response = JSON.parse(response.body, symbolize_names: true)
    end

    it 'finds all items that match, sorts alphabetically by name, and returns the first' do
      expect(response).to be_successful

      expect(@full_response).to have_key :data
      expect(@full_response[:data]).to be_a Hash
      item_data = @full_response[:data]

      expect(item_data).to have_key :id
      expect(item_data[:id]).to eq @item_2.id.to_s

      expect(item_data).to have_key :attributes
      expect(item_data[:attributes]).to be_a Hash

      expect(item_data[:attributes]).to have_key :name
      expect(item_data[:attributes][:name]).to eq @item_2.name

      expect(item_data[:attributes]).to have_key :description
      expect(item_data[:attributes][:description]).to eq @item_2.description

      expect(item_data[:attributes]).to have_key :unit_price
      expect(item_data[:attributes][:unit_price]).to eq @item_2.unit_price
    end
  end

  context 'searching by max_price, when a record is found' do
    before :each do
      search_params = { max_price: 50.75 }

      get '/api/v1/items/find', params: search_params

      @full_response = JSON.parse(response.body, symbolize_names: true)
    end

    it 'grabs all items that match, sorts alphabetically by name, and returns the first' do
      expect(response).to be_successful

      expect(@full_response).to have_key :data
      item_data = @full_response[:data]

      expect(item_data).to have_key :id
      expect(item_data[:id]).to eq @item_3.id.to_s

      expect(item_data).to have_key :attributes
      expect(item_data[:attributes]).to be_a Hash

      expect(item_data[:attributes]).to have_key :name
      expect(item_data[:attributes][:name]).to eq @item_3.name

      expect(item_data[:attributes]).to have_key :description
      expect(item_data[:attributes][:description]).to eq @item_3.description

      expect(item_data[:attributes]).to have_key :unit_price
      expect(item_data[:attributes][:unit_price]).to eq @item_3.unit_price
    end
  end

  context 'searching by both min_price and max_price, when a record is found' do
    before :each do
      search_params = { min_price: 50.25, max_price: 80 } 

      get '/api/v1/items/find', params: search_params

      @full_response = JSON.parse(response.body, symbolize_names: true)
    end

    it 'grabs all items that match, sorts alphabetically by name, and returns the first' do
      expect(response).to be_successful

      expect(@full_response).to have_key :data
      item_data = @full_response[:data]

      expect(item_data).to have_key :id
      expect(item_data[:id]).to eq @item_2.id.to_s

      expect(item_data).to have_key :attributes
      expect(item_data[:attributes]).to be_a Hash

      expect(item_data[:attributes]).to have_key :name
      expect(item_data[:attributes][:name]).to eq @item_2.name

      expect(item_data[:attributes]).to have_key :description
      expect(item_data[:attributes][:description]).to eq @item_2.description

      expect(item_data[:attributes]).to have_key :unit_price
      expect(item_data[:attributes][:unit_price]).to eq @item_2.unit_price
    end
  end

  context 'when a record is not found' do
    it 'returns an empty data object' do
      search_params = { max_price: 5 }

      get '/api/v1/items/find', params: search_params

      expect(response).to_not be_successful
      full_response = JSON.parse(response.body, symbolize_names: true)

      expect(full_response).to have_key :message
      expect(full_response[:message]).to eq 'your query could not be completed'

      expect(full_response).to have_key :errors
      expect(full_response[:errors]).to be_an Array
      expect(full_response[:errors]).to include 'you can not search for both name and price' 
    end
  end

  context 'if the user tries to send name and price in params' do
    before :each do
      search_params = { name: 'ring', max_price: 40 } 

      get '/api/v1/items/find', params: search_params

      @full_response = JSON.parse(response.body, symbolize_names: true)
    end

    it 'returns status code 404' do
      expect(response).to_not be_successful
      expect(response).to have_http_status 404
    end

    it 'returns an error message' do
      expect(@full_response).to have_key :message
      expect(@full_response[:message]).to eq 'your query could not be completed'

      expect(@full_response).to have_key :errors
      expect(@full_response[:errors]).to be_an Array
      expect(@full_response[:errors].length).to eq 1
      expect(@full_response[:errors][0]).to eq 'you can not search for both name and price'
    end
  end
end
