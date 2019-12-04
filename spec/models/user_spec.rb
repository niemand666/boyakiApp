require 'rails_helper'

RSpec.describe User, type: :model do
  include CarrierWave::Test::Matchers
  describe 'ユーザー新規登録' do
    # 1. 全ての項目を入力すれば登録できる
    it "is valid with a nickname, email, password, password_confirmation, image" do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe 'ユーザー新規登録(nicknameの妥当性の確認)' do
    # 2. nickname が空では登録できない
    it "is invalid without a nickname" do
     user = build(:user, nickname: nil)
     user.valid?
     expect(user.errors[:nickname]).to include("can't be blank")
    end

    # 3. nickname が21文字以上であれば登録できない
    it "is invalid with a nickname that has more than 21 characters" do
      user = build(:user, nickname: Faker::Lorem.characters(number: 21))
      user.valid?
      expect(user.errors[:nickname]).to include("is too long (maximum is 20 characters)")
    end

    # 4. nickname が20文字以下では登録できる
    it "is valid with a nickname that has less than 20 characters" do
      user = build(:user, nickname: Faker::Lorem.characters(number: 20))
      expect(user).to be_valid
    end
  end

  describe 'ユーザー新規登録(emailの妥当性の確認)' do
    # 5. email が空では登録できない
    it "is ivvalid without a email" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    # 6. 重複した email が存在する場合は登録できない
    it "is invalid with a duplicate email address" do
      user = create(:user)
      another_user = build(:user, email: user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include("has already been taken")
    end

    # 7. email がフォーマットに準拠していない場合は登録できない
    it "is invalid with a invalid e-mail format" do
      user = build(:user, email: 'aaaa')
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    # 8. @より前に値がない場合は登録できない
    it "is invalid, if there is no value before @" do
      user = build(:user, email: '@aaaa')
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    # 9. @より後に値がない場合は登録できない
    it "is invalid, if there is no value after @" do
      user = build(:user, email: 'aaaa@')
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    # 10. emailにカナ文字が含まれる場合は登録できない
    it "is invalid, if addres contains kana characters" do
      user = build(:user, email: 'aaあa@aaa')
      user.valid?
      expect(user.errors[:email]).to include()
    end
  end

  describe 'ユーザー新規登録(passwordの妥当性の確認)' do
    # 11. passwordが空欄では登録できない
    it "is invalid without a password" do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    # 12. passwordが存在してもpassword_confirmationが空欄では登録できない
    it "is invalid without a password_confirmation although with a password" do
      user = build(:user, password_confirmation: "")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    # 13. passwordが6文字以上であれば登録できる
    it "is valid with a password that has more than 6 characters" do
      user = build(:user, password: "000000", password_confirmation: "000000")
      user.valid?
      expect(user).to be_valid
    end

    # 14. passwordが5文字以下であれば登録できない
    it "is invalid with a password that has less than 5 characters" do
      user = build(:user, password: "00000", password_confirmation: "00000")
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    # 15. passwordとpassword_confirmationが一致しない場合は登録できない
    it "is invalid, if a password does not agree with a password_confirmation" do
      user = build(:user, password_confirmation: 'aaaa')
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  describe 'ユーザー新規登録(imageの妥当性の確認)' do
    # 16. imageが空欄では登録できない
    it "is invalid without a image" do
      user = build(:user, image: nil)
      user.valid?
      expect(user.errors[:image]).to include("can't be blank")
    end
  end
end
