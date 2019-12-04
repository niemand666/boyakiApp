FactoryBot.define do
  factory :picture do
    picture { File.open("#{Rails.root}/spec/fixtures/image.jpg") }
    post
  end
end
