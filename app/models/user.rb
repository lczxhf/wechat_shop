class User < ApplicationRecord
  has_one :user_setting
  has_one :gzh_config
  has_one :gzh_info
  has_many :members
  has_many :products
  enum status: [:probation,:normal,:expire]
  
  def can_authorize?
    !self.expire?
  end
end
