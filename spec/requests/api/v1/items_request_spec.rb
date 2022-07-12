require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'happy path' do
    it 'sends a list of items' do
      id_1 = create(:merchant).id
      id_2 = create(:merchant).id

      create_list(:item, 3, merchant_id: id_1)
      create_list(:item, 3, merchant_id: id_2)

      get '/api/v1/items'

      expect(response).to be_successful

      parsed_body = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_body).to have_key(:data)
      expect(parsed_body[:data]).to be_a Array

      items = parsed_body[:data]

      items.each do |item|
        expect(item).to have_key :id
        expect(item[:id]).to be_a String

        expect(item).to have_key :type
        expect(item[:type]).to eq('item')

        expect(item).to have_key :attributes

        expect(item[:attributes]).to have_key :name
        expect(item[:attributes][:name]).to be_a String

        expect(item[:attributes]).to have_key :description
        expect(item[:attributes][:description]).to be_a String

        expect(item[:attributes]).to have_key :unit_price
        expect(item[:attributes][:unit_price]).to be_a Float

        expect(item[:attributes]).to have_key :merchant_id
        expect(item[:attributes][:merchant_id]).to be_a Integer

        expect(item).to_not have_key :created_at
        expect(item).to_not have_key :updated_at
      end
    end

    it 'sends a single item' do
      id_1 = create(:merchant).id

      item_id = create(:item, merchant_id: id_1).id

      get "/api/v1/items/#{item_id}"

      expect(response).to be_successful

      parsed_body = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_body).to have_key(:data)
      expect(parsed_body[:data]).to be_a Hash

      item = parsed_body[:data]

      expect(item).to have_key :id
      expect(item[:id]).to be_a String

      expect(item).to have_key :type
      expect(item[:type]).to eq('item')

      expect(item).to have_key :attributes

      expect(item[:attributes]).to have_key :name
      expect(item[:attributes][:name]).to be_a String

      expect(item[:attributes]).to have_key :description
      expect(item[:attributes][:description]).to be_a String

      expect(item[:attributes]).to have_key :unit_price
      expect(item[:attributes][:unit_price]).to be_a Float

      expect(item[:attributes]).to have_key :merchant_id
      expect(item[:attributes][:merchant_id]).to be_a Integer

      expect(item).to_not have_key :created_at
      expect(item).to_not have_key :updated_at
    end

    it 'creates a single item' do
      merchant_id = create(:merchant).id

      item_params = {
        name: 'Spoon',
        description: "It's a spoon",
        unit_price: 1.1,
        merchant_id: merchant_id
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(response).to be_successful

      new_item = Item.last

      expect(new_item.name).to eq(item_params[:name])
      expect(new_item.description).to eq(item_params[:description])
      expect(new_item.unit_price).to eq(item_params[:unit_price])
      expect(new_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it 'updates a single item' do
      merchant_id = create(:merchant).id

      item_params = {
        name: 'Spoon',
        description: "It's a spoon",
        unit_price: 1.1,
        merchant_id: merchant_id
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      new_item = Item.last

      new_item_params = {
        description: "It's a spoon and a fork!"
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch "/api/v1/items/#{new_item.id}", headers: headers, params: JSON.generate(item: new_item_params)

      updated_item = Item.last

      expect(updated_item.description).to_not eq(new_item.description)

      expect(updated_item.name).to eq(new_item.name)
      expect(updated_item.unit_price).to eq(new_item.unit_price)
      expect(updated_item.merchant_id).to eq(new_item.merchant_id)
    end

    it 'destroys a single item' do
      merchant_id = create(:merchant).id
      item1 = create(:item, merchant_id: merchant_id)
      item2 = create(:item, merchant_id: merchant_id)

      customer = Customer.create!(first_name: 'Bryce', last_name: 'Wein')

      invoice = Invoice.create!(merchant_id: merchant_id, customer_id: customer.id)

      invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice.id)
      invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice.id)

      delete "/api/v1/items/#{item1.id}"

      expect(Item.exists?(item1.id)).to eq(false)
      expect(Item.exists?(item2.id)).to eq(true)
    end

    it 'destroys a invoice if last item is destroyed' do
      merchant_id = create(:merchant).id
      item1 = create(:item, merchant_id: merchant_id)
      item2 = create(:item, merchant_id: merchant_id)

      customer = Customer.create!(first_name: 'Bryce', last_name: 'Wein')

      invoice = Invoice.create!(merchant_id: merchant_id, customer_id: customer.id)

      invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice.id)
      invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice.id)

      delete "/api/v1/items/#{item1.id}"
      delete "/api/v1/items/#{item2.id}"

      expect(Item.exists?(item1.id)).to eq(false)
      expect(Item.exists?(item2.id)).to eq(false)

      expect(Invoice.exists?(invoice.id)).to eq(false)

      expect(response).to be_successful
      expect(response[:body]).to eq(nil)
    end
  end

  describe 'sad path' do
    it 'returns error if attribute is missing from create' do
      merchant_id = create(:merchant).id
      create(:item, merchant_id: merchant_id)

      item_params = {
        name: 'Spoon',
        description: "It's a spoon",
        merchant_id: merchant_id
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }

      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      expect(response).to_not be_successful

      new_item = Item.last

      expect(new_item.name).to_not eq(item_params[:name])
      expect(new_item.description).to_not eq(item_params[:description])
    end

    it 'returns an error if item does not exist' do
      merchant_id = create(:merchant).id

      item_params = {
        name: 'Spoon',
        description: "It's a spoon",
        unit_price: 1.1,
        merchant_id: merchant_id
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

      item = Item.last

      new_item_params = {
        description: "It's a spoon and a fork!"
      }

      headers = { 'CONTENT_TYPE' => 'application/json' }
      patch '/api/v1/items/5', headers: headers, params: JSON.generate(item: new_item_params)

      expect(response).to_not be_successful

      expect(item.description).to eq(item_params[:description])
    end
  end
end
