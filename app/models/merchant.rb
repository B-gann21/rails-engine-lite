class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices 
end
