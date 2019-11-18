require 'rails_helper'

describe Comment do
  describe '#create' do

    it "is invalid without a text" do
      comment = build(:comment, text: nil)
      comment.valid?
      expect(comment.errors[:text]).to include("can't be blank")
    end
  end
end
