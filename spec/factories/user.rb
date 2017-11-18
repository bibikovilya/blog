FactoryBot.define do
  factory :user do
    login Faker::Name.name
  end
end
