class ProductStock < ApplicationRecord
  belongs_to :member
  belongs_to :user
  belongs_to :product
end
