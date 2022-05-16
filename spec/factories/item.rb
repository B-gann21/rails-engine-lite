FactoryBot.define do 
  factory :item do
    name { Faker::Gamer.title } 
    description { Faker::Lorem.paragraph } 
    unit_price { Faker::Number.decimal(l_digits: [2, 3].sample, r_digits: 2) }
  end
end
