class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :post_id, presence: true
  validates :user_id, presence: true
  validates_uniqueness_of :post_id, scope: :user_id
  scope :recent, -> { includes(:user) }
end
