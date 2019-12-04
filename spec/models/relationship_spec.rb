require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe 'フォローの成立' do
    let(:user){create(:user)}
    let(:other_user){create(:other_user)}

    # 1. 存在する user_id と follow_id の場合はフォローが成立する
    it "is valid with a user_id and follow_id " do
      relationship = build(:relationship, user: user, follow: other_user)
      expect(relationship).to be_valid
    end
  
    # 2. user_id が存在しない場合は無効である
    it 'is invalid without a user_id' do
      relationship = build(:relationship, user: nil, follow: other_user)
      relationship.valid?
      expect(relationship.errors[:user]).to include('must exist')
    end

    # 3. follow_id が存在ない場合は無効である
    it 'is invalid without a follow_id' do
      relationship = build(:relationship, user: user, follow: nil)
      relationship.valid?
      expect(relationship.errors[:follow]).to include('must exist')
    end

    # 4. user_id と follow_id が重複する場合は無効である
    it 'is invalid with a duplicate user_id and follow_id pair' do
      relationship1 = create(:relationship, user: user, follow: other_user)
      expect(relationship1).to be_valid
      relationship2 = build(:relationship, user: user, follow: other_user)
      relationship2.valid?
      expect(relationship2.errors[:follow_id]).to include()
    end
  end
end
