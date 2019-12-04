require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '記事の投稿' do
    # 1. title と content があれば投稿できる
    it "is valid with a title and content" do
      post = build(:post)
      expect(post).to be_valid
    end

    # 2. title が空欄では投稿できない
    it "is invalid without a title" do
      post = build(:post, title: nil)
      post.valid?
      expect(post.errors[:title]).to include("can't be blank")
    end

    # 3. content が空欄では投稿できない
    it "is invalid without a content" do
      post = build(:post, content: nil)
      post.valid?
      expect(post.errors[:content]).to include("can't be blank")
    end
  end
end
