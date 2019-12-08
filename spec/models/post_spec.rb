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

    # 3. title が31文字以上では投稿できない
    it "is invalid with a title that has more than 31 characters" do
      post = build(:post, title: Faker::Lorem.characters(number: 31))
      post.valid?
      expect(post.errors[:title]).to include("is too long (maximum is 30 characters)")
    end

    # 4. title が30文字以下では投稿できる
    it "is valid with a title that has less than 30 characters" do
      post = build(:post, title: Faker::Lorem.characters(number: 30))
      expect(post).to be_valid
    end

    # 5. content が空欄では投稿できない
    it "is invalid without a content" do
      post = build(:post, content: nil)
      post.valid?
      expect(post.errors[:content]).to include("can't be blank")
    end

    # 6. content が201文字以上では投稿できない
    it "is invalid with a content that has more than 201 characters" do
      post = build(:post, content: Faker::Lorem.characters(number: 201))
      post.valid?
      expect(post.errors[:content]).to include("is too long (maximum is 200 characters)")
    end

    # 7. content が200文字以下では投稿できる
    it "is valid with a content that has less than 200 characters" do
      post = build(:post, content: Faker::Lorem.characters(number: 200))
      expect(post).to be_valid
    end
  end
end
