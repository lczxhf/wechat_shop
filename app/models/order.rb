class Order < ApplicationRecord
	belongs_to :shop
	belongs_to :member
	belongs_to :share_record

	has_many :order_products

	enum status: [:created,:pay,:sent,:comment,:done]
end
