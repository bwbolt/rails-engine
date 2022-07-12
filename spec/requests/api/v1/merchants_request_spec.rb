require 'rails_helper'

RSpec.describe 'Merchants API' do
  describe 'happy path' do
    it 'sends a list of merchants' do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful

      parsed_body = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_body).to have_key(:data)
      expect(parsed_body[:data]).to be_a Array

      merchants = parsed_body[:data]

      merchants.each do |merchant|
        expect(merchant).to have_key :id
        expect(merchant[:id]).to be_a String

        expect(merchant).to have_key :type
        expect(merchant[:type]).to eq('merchant')

        expect(merchant).to have_key :attributes

        expect(merchant[:attributes]).to have_key :name
        expect(merchant[:attributes][:name]).to be_a String

        expect(merchant).to_not have_key :created_at
        expect(merchant).to_not have_key :updated_at
      end
    end

    it 'sends a singular merchant' do
      merchant_id = create(:merchant).id

      get "/api/v1/merchants/#{merchant_id}"

      expect(response).to be_successful

      parsed_body = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_body).to have_key(:data)
      expect(parsed_body[:data]).to be_a Hash

      merchant = parsed_body[:data]

      expect(merchant).to have_key :id
      expect(merchant[:id]).to be_a String

      expect(merchant).to have_key :type
      expect(merchant[:type]).to eq('merchant')

      expect(merchant).to have_key :attributes

      expect(merchant[:attributes]).to have_key :name
      expect(merchant[:attributes][:name]).to be_a String

      expect(merchant).to_not have_key :created_at
      expect(merchant).to_not have_key :updated_at
    end
  end
end
