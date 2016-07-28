class ProductStock < ApplicationRecord
  belongs_to :member
  belongs_to :shop
  belongs_to :product
end
