class Image < ApplicationRecord
  belongs_to :product
  belongs_to :member

  mount_uploader :path,ProductImageUploader

  def image_path
  	self.path.url
  end
end
