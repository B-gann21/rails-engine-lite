require 'rails_helper'

RSpec.describe 'The Merchant Index endpoint' do
  before :each do
    create_list(:merchant, 5) do |merchant|
      create_list(:item, 3, merchant_id: merchant.id)
    end

    get '/api/v1/merchants'

    @full_response = JSON.parse(response.body, symbolize_names: true)
 
    @merchants = @full_response[:data]
  end

  it 'should return a collection of all merchants in the system' do
    expect(response).to be_successful
    expect(@merchants.count).to eq 5

    @merchants.each do |merchant|
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

  it 'does not return dependent data (invoices, items, etc)' do
    expect(response).to be_successful

    @merchants.each do |merchant|
      expect(merchant).to_not have_key :relationships
    end
  end
end
