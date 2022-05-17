require 'rails_helper' 

RSpec.describe InvoiceItem do
  context 'validations' do
    it { should validate_presence_of :quantity } 
    it { should validate_numericality_of :quantity }

    it { should validate_presence_of :unit_price } 
    it { should validate_numericality_of :unit_price }
  end

  context 'relationships' do
    it { should belong_to :invoice } 
    it { should belong_to :item } 
    it { should have_one(:merchant).through(:item) } 
    it { should have_many(:transactions).through(:invoice) } 
    it { should have_one(:customer).through(:invoice) } 
  end
end
