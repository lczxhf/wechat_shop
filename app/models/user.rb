class User < ApplicationRecord
  acts_as_cached(version:1,expires_in: 1.day)
  has_one :user_setting
  has_one :gzh_config
  has_one :gzh_info
  has_many :members
  has_many :products
  has_many :product_stocks
  has_many :agent_levels

  enum status: [:probation,:normal,:expire]

  after_create :init_setting

  def can_authorize?
    !self.expire?
  end

  def init_setting
     self.create_user_setting(u_type:1)
  end
end
