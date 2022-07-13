require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
  end

  describe 'model methods' do
    it '#find_all_name' do
      merchant_id = create(:merchant).id
      item1 = create(:item, name: 'Car', merchant_id: merchant_id)
      item2 = create(:item, name: 'Cart', merchant_id: merchant_id)
      item2 = create(:item, name: 'Carting', merchant_id: merchant_id)

      items = Item.find_all_name('rt')

      expect(items.length).to eq(2)
    end
    it '#find_all_range' do
      merchant_id = create(:merchant).id
      item1 = create(:item, unit_price: 5, merchant_id: merchant_id)
      item2 = create(:item, unit_price: 7, merchant_id: merchant_id)
      item2 = create(:item, unit_price: 10.1, merchant_id: merchant_id)

      items = Item.find_all_range(5, 10)

      expect(items.length).to eq(2)
    end
    it '#find_all_max_price' do
      merchant_id = create(:merchant).id
      item1 = create(:item, unit_price: 5, merchant_id: merchant_id)
      item2 = create(:item, unit_price: 7, merchant_id: merchant_id)
      item2 = create(:item, unit_price: 10.1, merchant_id: merchant_id)

      items = Item.find_all_max_price(10)

      expect(items.length).to eq(2)
    end
    it '#find_all_min_price' do
      merchant_id = create(:merchant).id
      item1 = create(:item, unit_price: 5, merchant_id: merchant_id)
      item2 = create(:item, unit_price: 7, merchant_id: merchant_id)
      item2 = create(:item, unit_price: 10.1, merchant_id: merchant_id)

      items = Item.find_all_min_price(10)

      expect(items.length).to eq(1)
    end
  end
  describe 'private methods' do
    it '#destroy_empty_invoices' do
      merchant_id = create(:merchant).id
      item1 = create(:item, merchant_id: merchant_id)

      customer = Customer.create!(first_name: 'Bryce', last_name: 'Wein')

      invoice = Invoice.create!(merchant_id: merchant_id, customer_id: customer.id)

      invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice.id)

      item1.destroy

      expect(Invoice.all).to be_empty
    end
  end
end
