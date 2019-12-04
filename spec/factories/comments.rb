FactoryBot.define do
  factory :comment do
    text {"いいね"}
    post
    user
  end
end
