class Image < ApplicationRecord
  belongs_to :product
  belongs_to :member

  mount_uploader :path,MediaUploader
end
