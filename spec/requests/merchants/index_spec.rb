require 'rails_helper'

RSpec.describe 'The Merchant Index endpoint' do
  it 'should return a collection of all merchants in the system' do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    full_response = JSON.parse(response.body, symbolize_names: true)
    expect(full_response).to have_key :data

    merchants = full_response[:data]

    merchants.each do |merchant|
      expect(merchant).to have_key :id
      expect(merchant[:id]).to be_a Integer

      expect(merchant).to have_key :type
      expect(merchant[:type]).to be_a String

      expect(merchant).to have_key :attributes
      expect(merchant[:attributes]).to be_a Hash

      expect(merchant[:attributes]).to have_key :name
      expect(merchant[:attributes][:name]).to be_a String
    end
  end
end
