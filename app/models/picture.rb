class Picture < ApplicationRecord
  belongs_to :post, optional: true
  mount_uploader :picture, ImageUploader

  validates :picture, presence: true

  #def self.parse_base64(pictures)
    #if pictures.present?
      #require 'base64'
      #pictures_binary_datas = []
      #pictures.each do |image|
        #binary_data = File.read(image.picture.file.file)
        #pictures_binary_datas << Base64.strict_encode64(binary_data)
      #end
    #end
  #end

end
