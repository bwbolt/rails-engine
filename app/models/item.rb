class Item < ApplicationRecord
  before_destroy :destroy_empty_invoices

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price

  def self.find_all_name(search)
    Item.where('name ILIKE ?', "%#{search}%") # .or(where('description ILIKE ?', "%#{search}%"))
    # uncomment above to find by description as well
  end

  def self.find_all_range(min, max)
    Item.where(unit_price: min..max)
  end

  def self.find_all_min_price(min)
    Item.where('unit_price > ?', min)
  end

  def self.find_all_max_price(max)
    Item.where('unit_price < ?', max)
  end

  private

  def destroy_empty_invoices
    invoices.each do |invoice|
      invoice.destroy if invoice.items.length == 1
    end
  end
end
