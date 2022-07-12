require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  describe 'happy path' do
    it 'sends a list of a merchants items' do
      id_1 = create(:merchant).id
      create_list(:item, 3, merchant_id: id_1)

      get "/api/v1/merchants/#{id_1}/items"

      expect(response).to be_successful

      parsed_body = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_body).to have_key(:data)
      expect(parsed_body[:data]).to be_a Array

      items = parsed_body[:data]

      expect(items.count).to eq(3)

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
  end

  describe 'sad path' do
    it 'returns proper sad path' do
      id_1 = create(:merchant).id
      create_list(:item, 3, merchant_id: id_1)

      get "/api/v1/merchants/#{id_1 + 1}/items"

      expect(response).to_not be_successful
    end
  end
end
