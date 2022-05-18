require 'rails_helper'

RSpec.describe 'Finding a single item' do
  before :each do
    merchant = create(:merchant)
    @item_1 = create(:item, name: 'Turing Handbook', merchant: merchant)
    @item_2 = create(:item, name: 'Ring VHS Tape', merchant: merchant)
    @item_3 = create(:item, description: 'Great for the summer heat!', merchant: merchant)
  end

  context 'when a record is found' do
    before :each do
      @search_params = { name: 'ring' }

      get '/api/v1/items/find', params: @search_params

      @full_response = JSON.parse(response.body, symbolize_names: true)
    end

    it 'returns the first item that matches by name, based on alphabetical order' do
      expect(response).to be_successful

      expect(@full_response).to have_key :data
      item_response = @full_response[:data]

      expect(item_response[:id]).to eq(@item_2.id.to_s)
    end

    it "if no names match, instead returns an item who's description matches" do
      search_params = { name: 'great' }

      get '/api/v1/items/find', params: search_params

      expect(response).to be_successful
      full_response = JSON.parse(response.body, symbolize_names: true)
      item_response = full_response[:data]

      expect(item_response[:id]).to eq(@item_3.id.to_s)
    end
  end
end
