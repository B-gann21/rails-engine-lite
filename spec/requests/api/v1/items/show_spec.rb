require 'rails_helper'

RSpec.describe 'Items Show Endpoint' do
  before :each do
    merchant = create(:merchant) do |merchant|
      create(:item, merchant: merchant)
    end

    get "/api/v1/items/#{merchant.items.first.id}"

    full_response = JSON.parse(response.body, symbolize_names: true)

    @item = full_response[:data]
  end

  it 'returns a JSON hash with data on the item' do
    expect(@item).to have_key :id
    expect(@item[:id]).to be_a String

    expect(@item).to have_key :type
    expect(@item[:type]).to eq('item')

    expect(@item).to have_key :attributes
    expect(@item[:attributes]).to be_a Hash

    expect(@item[:attributes]).to have_key :name
    expect(@item[:attributes][:name]).to be_a String

    expect(@item[:attributes]).to have_key :description
    expect(@item[:attributes][:description]).to be_a String

    expect(@item[:attributes]).to have_key :unit_price
    expect(@item[:attributes][:unit_price]).to be_a Float
  end
end
