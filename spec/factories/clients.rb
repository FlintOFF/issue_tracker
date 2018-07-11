FactoryBot.define do
  factory :client do
    email { Faker::Internet.email }
    password { 'password' }

    factory :client_with_issues do
      transient do
        issues_count 5
      end

      after(:create) do |client, evaluator|
        create_list(:issue, evaluator.issues_count, client: client)
      end
    end
  end
end