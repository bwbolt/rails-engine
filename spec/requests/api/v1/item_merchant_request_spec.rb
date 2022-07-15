require 'rails_helper'

RSpec.describe 'Item Merchant API' do
  describe 'happy path' do
    it 'returns an existing items merchant' do
      merchant1 = create(:merchant)
      item = create(:item, merchant_id: merchant1.id)

      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      parsed_body = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_body).to have_key(:data)

      merchant = parsed_body[:data]

      expect(merchant).to have_key :id
      expect(merchant[:id]).to be_a String

      expect(merchant).to have_key :type
      expect(merchant[:type]).to eq('merchant')

      expect(merchant).to have_key :attributes

      expect(merchant[:attributes]).to have_key :name
      expect(merchant[:attributes][:name]).to be_a String
      expect(merchant[:attributes][:name]).to eq(merchant1.name)

      expect(merchant).to_not have_key :created_at
      expect(merchant).to_not have_key :updated_at
    end
  end

  describe 'sad path' do
    it 'returns an error if item does not exist' do
      merchant1 = create(:merchant)
      item = create(:item, merchant_id: merchant1.id)

      get "/api/v1/items/#{item.id + 1}/merchant"

      expect(response).to_not be_successful
    end
  end
end
