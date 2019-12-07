class Picture < ApplicationRecord
  belongs_to :post, optional: true
  mount_uploader :picture, ImageUploader

  validates :picture, presence: true
end
