require 'rails_helper'

RSpec.describe 'Endpoint to find a single merchant' do
  before :each do
    @merchant_1 = create(:merchant, name: 'Turing')
    @merchant_2 = create(:merchant, name: 'Ring World')
    @merchant_3 = create(:merchant, name: 'Amazon')
  end

  context 'when a record is found' do
    before :each do
      @search_params = { name: 'ring' }

      get '/api/v1/merchants/find', params: @search_params

      @full_response = JSON.parse(response.body, symbolize_names: true)
    end

    it 'returns the first match in case-insensitive, alphabetical order' do
      expect(response).to be_successful
      expect(@full_response).to have_key :data

      merchant_data = @full_response[:data]
      expect(merchant_data).to be_a Hash

      expect(merchant_data).to have_key :id
      expect(merchant_data[:id]).to eq(@merchant_2.id.to_s)

      expect(merchant_data).to have_key :attributes
      expect(merchant_data[:attributes]).to be_a Hash

      expect(merchant_data[:attributes]).to have_key :name
      expect(merchant_data[:attributes][:name]).to eq 'Ring World'
    end
  end

  context 'when a record is not found' do
    it 'returns an empty JSON data object' do
      search_params = { name: 'NOMATCHPLEASE' }

      get '/api/v1/merchants/find', params: search_params

      full_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(full_response).to have_key :data
      expect(full_response[:data]).to be_a Hash
      expect(full_response[:data]).to be_empty
    end
  end
end
