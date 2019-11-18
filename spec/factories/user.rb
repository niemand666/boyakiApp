FactoryBot.define do

  factory :user do
    nickname              {Faker::Lorem.characters(number: 20)}
    password              {"00000000"}
    password_confirmation {"00000000"}
    image                 {File.open("#{Rails.root}/spec/fixtures/image.jpg")}
    sequence(:email)      {Faker::Internet.email}
  end

end
