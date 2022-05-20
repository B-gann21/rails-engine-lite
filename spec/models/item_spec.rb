require 'rails_helper'

RSpec.describe Item do
  context 'validation' do
    it { should validate_presence_of :name } 
    it { should validate_presence_of :description } 
    it { should validate_presence_of :unit_price } 
    it { should validate_numericality_of :unit_price } 
  end

  context 'relationships' do
    it { should belong_to :merchant } 
    it { should have_many :invoice_items } 
    it { should have_many(:invoices).through(:invoice_items) } 
    it { should have_many(:transactions).through(:invoices) } 
    it { should have_many(:customers).through(:invoices) } 
  end

  context 'class methods' do
    before :each do
      merchant = create(:merchant)
      @item_1 = create(:item, name: 'Turing Handbook', merchant: merchant)
      @item_2 = create(:item, name: 'Ring VHS Tape', merchant: merchant)
      @item_3 = create(:item, description: 'Great guide to computering', merchant: merchant)
    end

    describe '.find_first_by_name(name)' do
      it 'returns the first item that matches the given name, in alphabetical order' do
        expect(Item.find_first_by_name('ring')).to eq(@item_2)
      end

      it 'if no names match, checks the description instead' do
        expect(Item.find_first_by_name('great')).to eq(@item_3)
      end
    end

    it '.find_all_by_name(name) returns all items with names that match' do
      found_items = Item.find_all_by_name('ring')

      expect(found_items).to include(@item_1)
      expect(found_items).to include(@item_2)
      expect(found_items).to_not include(@item_3)
    end
  end

  context 'class methods to find an item by price' do
    before :each do
      merchant = create(:merchant)
      @item_1 = create(:item, name: 'Turing Handbook', unit_price: 50.50, merchant: merchant)
      @item_2 = create(:item, name: 'Ring VHS Tape', unit_price: 60,  merchant: merchant)
      @item_3 = create(:item, name: 'Something Special', unit_price: 50.01, merchant: merchant)
      @item_4 = create(:item, name: 'Alpha', unit_price: 75, merchant: merchant)
    end

    it '.find_first_by_min_price(price) finds all items that match, sorts alphabetically by name, and returns the first' do
      expect(Item.find_first_by_min_price(50.25)).to eq @item_4
    end

    it '.find_first_by_max_price(price) finds all items that match, sorts alphabetically by name, and retunrs the first' do
      expect(Item.find_first_by_max_price(70)).to eq @item_2
    end

    it '.find_first_by_price_range(min, max) finds all items that match, sorts slphabeticallyby name, and returns the first' do
      expect(Item.find_first_by_price_range(60, 80)).to eq(@item_4)
    end

    describe '.find_first_by_params(params)' do
      it 'you can not send name with price in query params' do
        params = { name: 'ring', min_price: 50 }

        expect(Item.find_first_by_params(params)).to be_falsey
      end

      it 'returns .find_first_by_name(name) if params only has name' do
        params = { name: 'ring' } 

        expect(Item.find_first_by_params(params)).to eq(Item.find_first_by_name('ring'))
      end

      it 'returns .find_first_by_max_price(price) if just max price is given' do
        params = { max_price: 70 } 

        expect(Item.find_first_by_params(params)).to eq(Item.find_first_by_max_price(70))
      end

      it 'returns .find_first_by_min_price(price) if just min price is given' do
        params = { min_price: 50 } 

        expect(Item.find_first_by_params(params)).to eq(Item.find_first_by_min_price(50))
      end

      it 'returns .find_first_by_price_range(range) if both min and max price are given' do
        params = { min_price: 60, max_price: 80 } 

        expect(Item.find_first_by_params(params)).to eq(Item.find_first_by_price_range(60, 80))
      end
    end
  end
end
