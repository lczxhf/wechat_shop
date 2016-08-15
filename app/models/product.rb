class Product < ApplicationRecord
  include Redis::Objects
  belongs_to :shop
  belongs_to :member
  has_many :images,dependent: :destroy
  has_many :level_distributions,dependent: :destroy
  has_many :share_products
  has_many :product_stocks
  has_many :qrcode_images,dependent: :destroy

  enum status: [:normal,:due]

  value :main_image

  def get_stock
  	 self.stock || 999
  end

  def free_postage?
  		self.postage == 0
  end

  def get_image
  	  self.main_image.value || self.images.first.path.thumb.url
  end
end
