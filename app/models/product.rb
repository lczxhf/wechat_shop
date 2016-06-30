class Product < ApplicationRecord
  belongs_to :user
  belongs_to :member
  has_many :images
  has_one :level_distribution
  has_many :share_products
end
