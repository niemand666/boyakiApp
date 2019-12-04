FactoryBot.define do
  factory :relationship do
    user
    follow factory: :other_user
  end
end
