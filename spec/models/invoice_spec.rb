require 'rails_helper' 

RSpec.describe Invoice do
  context 'validation' do
    it { should validate_presence_of :status } 
    it { should define_enum_for(:status).with_values(['shipped', 'packaged', 'returned']) } 
  end

  context 'relationships' do
    it { should belong_to :customer } 
    it { should belong_to :merchant } 
    it { should have_many :transactions } 
    it { should have-many :invoice_items } 
    it { should have_many(:items).through(:invoice_items) } 
  end
end
