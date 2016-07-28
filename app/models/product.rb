class Product < ApplicationRecord
  belongs_to :shop
  belongs_to :member
  has_many :images
  has_many :level_distributions
  has_many :share_products
  has_many :product_stocks
  has_many :qrcode_images

  enum status: [:normal,:due]
  def get_stock
  	 self.stock || 999
  end

  def free_postage?
  		self.postage == 0
  end
end
