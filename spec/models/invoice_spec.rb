require 'rails_helper' 

RSpec.describe Invoice do
  context 'validation' do
    it { should validate_presence_of :status } 
  end

  context 'relationships' do
    it { should belong_to :customer } 
    it { should belong_to :merchant } 
    it { should have_many :transactions } 
    it { should have_many :invoice_items } 
    it { should have_many(:items).through(:invoice_items) } 
  end
  
  it 'is a test to check how gh actions works' do
    expect(1+1).to eq 2
  end
end
