class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :notifications, dependent: :destroy

  validates :text, presence: true
  
  scope :recent, -> { includes(:user) }
  scope :active, -> { order(created_at: :DESC) }
end
