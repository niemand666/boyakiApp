require 'rails_helper'

describe Post do
  describe '#create' do
    # 1. タイトルが空では投稿できないこと
    it "is invalid without a title" do
      post = build(:post, title: nil)
      post.valid?
      expect(post.errors[:title]).to include("can't be blank")
    end

    # 2. 本文が空では投稿できないこと
    it "is invalid without a content" do
      post = build(:post, content: nil)
      post.valid?
      expect(post.errors[:content]).to include("can't be blank")
    end
  end
end
