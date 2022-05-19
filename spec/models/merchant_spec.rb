require 'rails_helper'

RSpec.describe Merchant do
  context 'validation' do
    it { should validate_presence_of :name } 
  end

  context 'relationships' do
    it { should have_many :items } 
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices) } 
    it { should have_many(:customers).through(:invoices) } 
    it { should have_many(:transactions).through(:invoices) } 
  end

  context 'class methods' do
    before :each do
      @merchant_1 = create(:merchant, name: 'Turing')
      @merchant_2 = create(:merchant, name: 'Ring World')
      @merchant_3 = create(:merchant, name: 'Amazon')
    end

    it '.find_first_by_name(name) returns the first case-insensitive, alphabetical match' do
      expect(Merchant.find_first_by_name('ring')).to eq @merchant_2
    end

    it '.find_all_by_name(name) returns all case-insensitive matches' do
      found_merchants = Merchant.find_all_by_name('ring')

      expect(found_merchants).to be_a Array
      expect(found_merchants).to include @merchant_1
      expect(found_merchants).to include @merchant_2
      expect(found_merchants).to_not include @merchant_3
    end
  end
end
