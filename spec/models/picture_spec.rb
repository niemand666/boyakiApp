require 'rails_helper'

RSpec.describe Picture, type: :model do
  include CarrierWave::Test::Matchers
  describe '#create' do
    # 1. picture が空欄では登録できない
    it "is invalid without picture" do
      picture = build(:picture, picture: nil)
      picture.valid?
      expect(picture.errors[:picture]).to include("can't be blank")
    end
  end
end
