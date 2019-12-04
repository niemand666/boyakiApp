FactoryBot.define do
  factory :post do
    title      {"タイトル"}
    content    {"内容"}
    created_at { Faker::Time.between(from: DateTime.now - 2, to: DateTime.now) }
    user
  end
end
