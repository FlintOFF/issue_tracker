# require 'factory_girl_rails'

FactoryBot.define do
  factory :issue do
    title { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
    client
    manager
  end
end
