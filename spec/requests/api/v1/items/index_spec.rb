require 'rails_helper'

RSpec.describe 'Items Index Endpoint' do
  before :each do
    create_list(:merchant, 5) do |merchant|
      create_list(:item, 3, merchant: merchant)
    end

    create_list(:customer, 5) do |cust|
      create(:invoice, customer: cust, merchant: Merchant.all.sample) do |invoice|
        create(:transaction, invoice: invoice)
        create_list(:invoice_item, 3, invoice: invoice, item: Item.all.sample)
      end
    end

    get '/api/v1/items'

    @full_response = JSON.parse(response.body, symbolize_names: true)
 
    @items = @full_response[:data]
  end

  it 'returns a collections of all items in the database' do
    expect(response).to be_successful
    expect(@items.count).to eq 15

    @items.each do |item|
      expect(item).to have_key :id
      expect(item[:id]).to be_a String

      expect(item).to have_key :type
      expect(item[:type]).to eq('item')

      expect(item).to have_key :attributes
      expect(item[:attributes]).to be_a Hash

      expect(item[:attributes]).to have_key :name
      expect(item[:attributes][:name]).to be_a String
      
      expect(item[:attributes]).to have_key :description
      expect(item[:attributes][:description]).to be_a String

      expect(item[:attributes]).to have_key :unit_price
      expect(item[:attributes][:unit_price]).to be_a Float

      expect(item[:attributes]).to have_key :merchant_id
      expect(item[:attributes][:merchant_id]).to be_a Integer
    end
  end

  it 'still returns a data object if no items exist' do
    InvoiceItem.destroy_all
    Item.destroy_all

    get '/api/v1/items'

    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)

    expect(response_body).to have_key :data
    expect(response_body[:data]).to be_a Array
  end

  it 'does not return dependent data (invoice_items, invoices, etc)' do
    expect(response).to be_successful

    @items.each do |item|
      expect(item).to_not have_key :relationships
    end
  end
end
