FactoryBot.define do
  factory :invoice do
    status { ['returned', 'packaged', 'shipped'].sample } 
  end
end
