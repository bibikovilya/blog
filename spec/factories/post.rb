FactoryBot.define do
  factory :post do
    user
    title Faker::Lorem.sentences
    body Faker::Lorem.paragraph
    ip Faker::Internet.ip_v4_cidr
  end
end
