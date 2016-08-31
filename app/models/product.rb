class Product < ApplicationRecord
  include Redis::Objects
  belongs_to :shop
  belongs_to :member
  has_many :images,dependent: :destroy
  has_many :level_distributions,dependent: :destroy
  has_many :share_products
  has_many :product_stocks
  has_many :qrcode_images,dependent: :destroy

  has_many :order_products

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

  def self.counter_total_price(products,sum_arr)
  		products.each_with_index.inject(0) do |result,arr|
			result + arr[0].price*sum_arr[arr[1]].to_i
		end	
  end

  def check_stock(sum)
  	  self.get_stock >= sum.to_i
  end

  def check_member_stock(member_id,sum)
		ProductStock.where(member_id:member_id,product_id:self.id).where("count >= #{sum}").present?
  end

  def reduce_stock(sum)
	 if self.get_stock != 999
	 	self.stock = self.stock - sum
		self.save!
	 end
  end
  def generate_order_product(order_id,sum,params={})
		OrderProduct.create!(order_id:order_id,product_id:self.id,sum:sum,price:self.price)
		if params[:is_store]
			ProductStock.create!(product_id:self.id,shop_id:params[:shop_id],member_id:params[:member_id],order_id:order_id,count:sum)
		else
			self.reduce_stock(sum)
		end
  end
end
