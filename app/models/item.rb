class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.find_first_by_name(name)
    check = where("name ILIKE '%#{name}%'")
      .order(:name)
      .first
    if check
      check
    else
      where("description ILIKE '%#{name}%'")
        .order(:name)
        .first
    end
  end
end
