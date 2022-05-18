require 'rails_helper'

RSpec.describe "Merchant's Items Endpoint" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @item_1a = create(:item, merchant: @merchant_1)
    @item_1b = create(:item, merchant: @merchant_1)
    @item_1c = create(:item, merchant: @merchant_1)

    @item_2 = create(:item, merchant: @merchant_2)

    @full_response = JSON.parse(response.body, symbolize_names: true)

    get "/api/v1/merchants/#{@merchant_1.id}/items"
  end

  context 'when a valid ID is given' do
    it "returns status code 200 with data on all of that merchant's items" do
      expect(response).to be_successful
      expect(response).to have_http_status 200
      expect(@full_response).to have_key :data
      
      items_data = @full_response[:data]
      expect(items_data).to be_an Array
      expect(items_data).to be_all Hash
      expect(items_data.count).to eq 3
    end

    it 'data on items is accurate and in proper JSON format' do
      items_data = @full_response[:data]
      item_1a_data = items_data[0]
      item_1b_data = items_data[1]
      
      # check if item_1a_data is accurate
      expect(item_1a_data).to have_key :id
      expect(item_1a_data[:id]).to eq(@item_1a.id)
      expect(item_1a_data).to have_key :type
      expect(item_1a_data[:type]).to eq 'item'

      expect(item_1a_data).to have_key :attributes
      expect(item_1a_data[:attributes]).to be_a Hash

      expect(item_1a_data[:attributes]).to have_key :name
      expect(item_1a_data[:attributes][:name]).to eq(@item_1a.name)

      expect(item_1a_data[:attributes]).to have_key :description
      expect(item_1a_data[:attributes][:description]).to eq(@item_1a.description)

      expect(item_1a_data[:attributes]).to have_key :unit_price
      expect(item_1a_data[:attributes][:unit_price]).to eq(@item_1a.unit_price)

      expect(item_1a_data[:attributes]).to have_key :merchant_id
      expect(item_1a_data[:attributes][:merchant_id]).to eq(@item_1a.merchant_id)
      
      # check if item_1b_data is accurate
      expect(item_1b_data).to have_key :id
      expect(item_1b_data[:id]).to eq(@item_1b.id)
      expect(item_1b_data).to have_key :type
      expect(item_1b_data[:type]).to eq 'item'

      expect(item_1b_data).to have_key :attributes
      expect(item_1b_data[:attributes]).to be_a Hash

      expect(item_1b_data[:attributes]).to have_key :name
      expect(item_1b_data[:attributes][:name]).to eq(@item_1b.name)

      expect(item_1b_data[:attributes]).to have_key :description
      expect(item_1b_data[:attributes][:description]).to eq(@item_1b.description)

      expect(item_1b_data[:attributes]).to have_key :unit_price
      expect(item_1b_data[:attributes][:unit_price]).to eq(@item_1b.unit_price)

      expect(item_1b_data[:attributes]).to have_key :merchant_id
      expect(item_1b_data[:attributes][:merchant_id]).to eq(@item_1b.merchant_id)
    end

    it 'does not show information on items that do not belong to the merchant' do
      items_data = @full_resonse[:data]

      items_data.each do |item|
        expect(item[:id]).to_not match @item_2.id
        expect(item[:attributes][:name]).to_not match @item_2.name
        expect(item[:attributes][:description]).to_not match @item_2.description
        expect(item[:attributes][:unit_price]).to_not match @item_2.unit_price
      end
    end
  end

  context 'when an invalid ID is given' do
    before :each do
      get "/api/v1/merchants/#{@merchant.id - 1}/items"
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
      expect(response_body[:errors][0]).to eq("no merchant found with an ID of #{@merchant.id - 1}")
    end
  end
end
