require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
  end
  describe 'model methods' do
    it '#find_by_name' do
      merchant1 = Merchant.create!(name: 'Frank')
      merchant2 = Merchant.create!(name: 'Frankfurt')
      merchant3 = Merchant.create!(name: 'Frankfurtnoodle')

      merchant = Merchant.find_by_name('kf')

      name = JSON.parse(merchant.to_json, symbolize_names: true)[:data][:attributes][:name]

      expect(name).to eq(merchant2.name)
    end
  end
end
