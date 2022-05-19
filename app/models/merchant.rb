class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices 

  def self.find_first_by_name(name)
    where("name ILIKE '%#{name}%'")
      .order(:name)
      .first
  end
end
