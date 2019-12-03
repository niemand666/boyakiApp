class Picture < ApplicationRecord
  belongs_to :post, optional: true
  mount_uploader :picture, ImageUploader
end
