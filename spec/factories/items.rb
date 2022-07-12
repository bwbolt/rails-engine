FactoryBot.define do
  factory :item do
    name { Faker::Movies::HarryPotter.spell }
    description { Faker::Movies::HarryPotter.quote }
    unit_price { Faker::Number.within(range: 1..1_000_000) }
    merchant { nil }
  end
end
