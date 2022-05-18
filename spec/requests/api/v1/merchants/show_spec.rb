require 'rails_helper'

RSpec.describe 'Merchant Show endpoint' do
  context 'when a valid id is given' do
    before :each do
      merchant = create(:merchant)

      get "/api/v1/merchants/#{merchant.id}"

      full_response = JSON.parse(response.body, symbolize_names: true)

      @merchant = full_response[:data]
    end

    it 'returns a JSON object with data on the merchant' do
      expect(@merchant).to have_key :id
      expect(@merchant[:id]).to be_a String

      expect(@merchant).to have_key :type
      expect(@merchant[:type]).to eq('merchant')

      expect(@merchant).to have_key :attributes
      expect(@merchant[:attributes]).to be_a Hash

      expect(@merchant[:attributes]).to have_key :name
      expect(@merchant[:attributes][:name]).to be_a String
    end
  end

  context 'when an invalid id is given' do
    before :each do
      @merchant = create(:merchant)
      get "/api/v1/merchants/#{@merchant.id - 1}"
    end

    it 'returns status code 404 if the :id is not found' do
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
