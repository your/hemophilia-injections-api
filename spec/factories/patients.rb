FactoryBot.define do
  factory :patient do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    date_of_birth { Faker::Date.birthday(min_age: 0, max_age: 100) }
    api_key { SecureRandom.hex(16) }
  end
end
