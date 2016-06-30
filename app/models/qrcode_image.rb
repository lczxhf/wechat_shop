class QrcodeImage < ApplicationRecord
  belongs_to :member
  belongs_to :image
  belongs_to :product

  mount_uploader :path,MediaUploader
end
