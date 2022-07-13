class Merchant < ApplicationRecord
  has_many :items

  def self.find_by_name(search)
    merchant = Merchant.find_by('name ILIKE ?', "%#{search}%")
    if merchant.nil?
      { data: {} }
    else

      MerchantSerializer.new(merchant)
    end
  end
end
