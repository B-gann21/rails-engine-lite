require 'rails_helper'

RSpec.describe "Item's Merchant endpoint" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @item = create(:item, merchant: @merchant_1)

    get "/api/v1/items/#{@item.id}/merchant"

    @full_response = JSON.parse(response.body, symbolize_names: true)
  end

  context 'when a valid ID is given' do
    it 'returns status code 200 with a JSON data object' do
      expect(response).to be_successful
      expect(@full_response).to have_key :data
      expect(@full_response[:data]).to be_a Hash

      expect(@full_response[:data]).to have_key :id
      expect(@full_response[:data][:id]).to eq(@merchant_1.id.to_s)

      expect(@full_response[:data]).to have_key :type
      expect(@full_response[:data][:type]).to eq 'merchant'

      expect(@full_response[:data]).to have_key :attributes
      expect(@full_response[:data][:attributes]).to be_a Hash

      expect(@full_response[:data][:attributes]).to have_key :name
      expect(@full_response[:data][:attributes][:name]).to eq(@merchant_1.name)
    end

    it 'does not return information on other merchants' do
      expect(@full_response[:data].keys.count(:id)).to eq 1
      expect(@full_response[:data][:id]).to_not eq(@merchant_2.id.to_s)
    end
  end

  context 'when an invalid ID is given' do
    before :each do
      get "/api/v1/items/#{@item.id - 1}/merchant"
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
