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
end
