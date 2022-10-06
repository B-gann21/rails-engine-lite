FactoryBot.define do 
  factory :customer do
    # creates a customer using faker
    first_name { Faker::Name.first_name } 
    last_name { Faker::Name.last_name }
  end
end
