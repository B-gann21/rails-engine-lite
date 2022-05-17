require 'rails_helper'

RSpec.describe 'Merchant Show endpoint' do
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
