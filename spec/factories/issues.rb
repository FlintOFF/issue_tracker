# require 'factory_girl_rails'

FactoryBot.define do
  factory :issue do

    # association :client, factory: :client
    # association :manager, factory: :manager
    # initialize_with { new(client: client) }

    # client  create(:client)


    title { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
    client
    manager
  end
end
