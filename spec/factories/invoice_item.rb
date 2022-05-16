FactoryBot.define do 
  factory :invoice_item do
    quantity { Faker::Number.within(range: 1..20) }
    unit_price { Faker::Number.decimal }
  end
end
