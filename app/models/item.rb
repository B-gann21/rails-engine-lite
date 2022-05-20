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
    validator = name_check(name)

    if validator
      return validator
    else
      return description_check(name)
    end
  end

  def self.find_all_by_name(name)
    where("name ILIKE '%#{name}%'") 
      .order(:name)
  end

  def self.find_first_by_min_price(price)
    where("unit_price > #{price}")
      .order(:name)
      .first
  end

  def self.find_first_by_max_price(price)
    where("unit_price < #{price}")
      .order(:name)
      .first
  end

  def self.find_first_by_price_range(min, max)
    where("unit_price > #{min}")
      .where("unit_price < #{max}")
      .order(:name)
      .first
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
