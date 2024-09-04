FactoryBot.define do
  factory :injection do
    dose_mm { rand(1.0..100.0).round(2) }
    lot_number { Faker::Alphanumeric.alphanumeric(number: 6).upcase }
    drug_name { Faker::Commerce.product_name }
    date { Faker::Date.between(from: 2.days.ago, to: Date.today) } # Random date within the last 2 days
    association :patient
  end
end
