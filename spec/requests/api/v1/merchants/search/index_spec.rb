require 'rails_helper' 

RSpec.describe 'Endpoint to find all merchants' do
  before :each do
    @merchant_1 = create(:merchant, name: 'Turing')
    @merchant_2 = create(:merchant, name: 'Ring World')
    @merchant_3 = create(:merchant, name: 'Amazon')
  end

  context 'when records are found' do
    it 'returns JSON data on all items with names that match' do
      search_params = { name: 'ring' } 

      get '/api/v1/merchants/find_all', params: search_params

      full_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(full_response).to have_key :data
      expect(full_response[:data]).to be_an Array
      expect(full_response[:data].count).to eq 2

      merchants_data = full_response[:data]

      merchants_data.each do |merchant|
        expect(merchant).to have_key :id
        expect(merchant[:id]).to_not eq(@merchant_3.id.to_s)

        expect(merchant).to have_key :type
        expect(merchant[:type]).to eq('merchant')

        expect(merchant).to have_key :attributes
        expect(merchant[:attributes]).to be_a Hash

        expect(merchant[:attributes]).to have_key :name
        expect(merchant[:attributes][:name]).to_not eq(@merchant_3.name)
      end
    end
  end

  context 'when records are not found' do
    it 'returns an empty JSON data object' do
      search_params = { name: 'NOMATCHPLEASE' }

      get '/api/v1/merchants/find_all', params: search_params

      full_response = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful

      expect(full_response).to have_key :data
      expect(full_response[:data]).to be_an Array
      expect(full_response[:data]).to be_empty
    end
  end
end
