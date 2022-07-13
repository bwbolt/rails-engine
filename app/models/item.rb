class Item < ApplicationRecord
  before_destroy :destroy_empty_invoices

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price

  def self.find_all_name(search)
    a = Item.where('name ILIKE ?', "%#{search}%").or(where('description ILIKE ?', "%#{search}%"))
    # binding.pry
  end

  private

  def destroy_empty_invoices
    invoices.each do |invoice|
      invoice.destroy if invoice.items.length == 1
    end
  end
end
