require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#create' do
    let(:post) { create(:post) }
    let(:user) { create(:user) }

    # 1. コメント有効
    it "is valid with a text and user_id and post_id" do
      comment = build(:comment)
      expect(comment).to be_valid
    end

    # 2. text が空欄の場合は無効
    it "is invalid without a text" do
      comment = build(:comment, text: nil, user: user, post: post)
      comment.valid?
      expect(comment.errors[:text]).to include("can't be blank")
    end

    # 3. user_id が存在しない場合は無効
    it 'is invalid without a user_id' do
      like = build(:comment, text: 'いいね', user: nil, post: post)
      like.valid?
      expect(like.errors[:user]).to include('must exist')
    end

    # 4. post_id が存在しない場合は無効
    it 'is invalid without a post_id' do
      like = build(:comment, text: 'いいね', user: user, post: nil)
      like.valid?
      expect(like.errors[:post]).to include('must exist')
    end
  end
end
