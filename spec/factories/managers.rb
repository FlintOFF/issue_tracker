FactoryBot.define do
  factory :manager do
    email { Faker::Internet.email }
    password { 'password' }
  end
end