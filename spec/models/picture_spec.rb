require 'rails_helper'

RSpec.describe Picture, type: :model do
  include CarrierWave::Test::Matchers
  describe '#create' do
    let(:post) { create(:post) }

    # 1. 登録可能
    it "is valid with a picture and post_id" do
      picture = build(:picture)
      expect(picture).to be_valid
    end

    # 2. picture が空欄では登録できない
    it "is invalid without picture" do
      picture = build(:picture, picture: nil, post: post)
      picture.valid?
      expect(picture.errors[:picture]).to include("can't be blank")
    end

    # 3. post_id が存在しない場合は登録できない
    it "is invalid without picture" do
      picture = build(:picture, picture: File.open("#{Rails.root}/spec/fixtures/image.jpg"), post: nil)
      picture.valid?
      expect(picture.errors[:post]).to include()
    end
  end
end
