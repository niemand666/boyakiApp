FactoryBot.define do

  factory :user do
    nickname              {Faker::Lorem.characters(number: 20)}
    email                 {"kkk@gmail.com"}
    password              {"00000000"}
    password_confirmation {"00000000"}
    image {File.open("#{Rails.root}/spec/fixtures/image.jpg")}
  end

end