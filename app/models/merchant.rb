class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices 

  def self.find_first_by_name(name)
    find_all_by_name(name).first
  end

  def self.find_all_by_name(name)
    where("name ILIKE '%#{name}%'")
      .order(:name)
      .compact
  end

  def self.find_top_merchants_by_quantity(quantity)
    select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .joins(invoices: {invoice_items: :transactions})
      .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
      .group(:id)
      .order(revenue: :desc)
      .limit(quantity)
  end

  def self.find_top_merchants_by_items_sold(quantity = 5)
    select('merchants.*, SUM(invoice_items.quantity) AS count')
      .joins(invoices: [:invoice_items, :transactions])
      .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
      .order(count: :desc)
      .group(:id)
      .limit(quantity)
  end
end
