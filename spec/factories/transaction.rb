FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Business.credit_card_number } 
    credit_card_expiration_date { 
      "#{Faker::Number.within(range: 1..12).to_s.rjust(2, '0')}/#{Faker::Number.within(range: 23..33)}" 
    }
    status { ['success', 'failed', 'refunded'].sample }
  end
end
