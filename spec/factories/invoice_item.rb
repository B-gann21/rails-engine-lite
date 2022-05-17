FactoryBot.define do 
  factory :invoice_item do
    quantity { Faker::Number.within(range: 1..20) }
    unit_price { Faker::Number.decimal(l_digits: [2, 3].sample, r_digits: 2) }
  end
end
