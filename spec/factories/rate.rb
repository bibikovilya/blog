FactoryBot.define do
  factory :rate do
    post
    value Faker::Number.between(1, 5)
  end
end
