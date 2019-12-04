require 'rails_helper'

RSpec.describe Like, type: :model do
  describe '#create' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }

    # 1. 存在する user_id と post_id の場合はいいねが成立する
    it "is valid with a user_id and post_id " do
      like = build(:like, user: user, post: post)
      expect(like).to be_valid
    end

    # 2. user_id が存在しない場合は無効である
    it 'is invalid without a user_id' do
      like = build(:like, user: nil, post: post)
      like.valid?
      expect(like.errors[:user]).to include('must exist')
    end

    # 3. post_id が存在ない場合は無効である
    it 'is invalid without a post_id' do
      like = build(:like, user: user, post: nil)
      like.valid?
      expect(like.errors[:post]).to include('must exist')
    end

    # 4. user_id と post_id が重複する場合は無効である
    it 'is invalid with a duplicate user_id and post_id pair' do
      like1 = create(:like, user: user, post: post)
      expect(like1).to be_valid
      like2 = build(:like, user: user, post: post)
      like2.valid?
      expect(like2.errors[:post_id]).to include('has already been taken')
    end
  end
end
