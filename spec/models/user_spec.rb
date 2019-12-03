require 'rails_helper'

RSpec.describe User, type: :model do
  include CarrierWave::Test::Matchers
  describe '#create' do
    # 1. 全ての項目を入力すれば登録できる
    it "is valid with a nickname, email, password, password_confirmation, image" do
      user = build(:user)
      expect(user).to be_valid
    end

    # 2. nicknameが空では登録できない
    it "is invalid without a nickname" do
     user = build(:user, nickname: nil)
     user.valid?
     expect(user.errors[:nickname]).to include("can't be blank")
    end

    # 3. emailが空では登録できない
    it "is ivvalid without a email" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    # 4. passwordが空では登録できない
    it "is invalid without a password" do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    # 5. passwordが存在してもpassword_confirmationが空では登録できない
    it "is invalid without a password_confirmation although with a password" do
      user = build(:user, password_confirmation: "")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    # 6. imageが空では登録できない
    it "is invalid without a image" do
      user = build(:user, image: nil)
      user.valid?
      expect(user.errors[:image]).to include("can't be blank")
    end

    # 7. nicknameが21文字以上であれば登録できない
    it "is invalid with a nickname that has more than 21 characters " do
      user = build(:user, nickname: Faker::Lorem.characters(number: 21))
      user.valid?
      expect(user.errors[:nickname]).to include("is too long (maximum is 20 characters)")
    end

    # 8. nicknameが20文字以下では登録できる
    it "is valid with a nickname that has less than 20 characters " do
      user = build(:user, nickname: Faker::Lorem.characters(number: 20))
      expect(user).to be_valid
    end

    # 9. 重複したemailが存在する場合は登録できない
    it "is invalid with a duplicate email address" do
      user = create(:user)
      another_user = build(:user, email: user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include("has already been taken")
    end

    # 10. passwordが6文字以上であれば登録できる
    it "is valid with a password that has more than 6 characters " do
      user = build(:user, password: "000000", password_confirmation: "000000")
      user.valid?
      expect(user).to be_valid
    end

    # 11. passwordが5文字以下であれば登録できない
    it "is invalid with a password that has less than 5 characters " do
      user = build(:user, password: "00000", password_confirmation: "00000")
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end
 end
 