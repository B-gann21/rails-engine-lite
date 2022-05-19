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
    if !name_check(name).nil?
      return name_check(name)
    else
      return description_check(name)
    end
  end

  def self.find_all_by_name(name)
    where("name ILIKE '%#{name}%'") 
      .order(:name)
  end

  private

  def self.name_check(name)
    where("name ILIKE '%#{name}%'")
      .order(:name)
      .first
  end

  def self.description_check(name)
    where("description ILIKE '%#{name}%'")
      .order(:name)
      .first
  end
end
