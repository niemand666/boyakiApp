FactoryBot.define do
  # 本人
  factory :user do
    nickname              { Faker::Lorem.characters(number: 20) }
    password              { "00000000" }
    password_confirmation { "00000000" }
    image                 { File.open("#{Rails.root}/spec/fixtures/icon.png") }
    sequence(:email)      { Faker::Internet.email }
  end
  
  # 他人
  factory :other_user, class: User do
    nickname              { Faker::Lorem.characters(number: 20) }
    password              { "11111111" }
    password_confirmation { "11111111" }
    image                 { File.open("#{Rails.root}/spec/fixtures/icon.png") }
    sequence(:email)      { Faker::Internet.email }
  end
end
