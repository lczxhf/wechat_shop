class User < ApplicationRecord
  acts_as_cached(version:1,expires_in: 1.day)
  has_one :user_setting
  has_one :gzh_config
  has_one :gzh_info
  has_many :members

  enum status: [:probation,:normal,:expire]

  after_create :init_setting

  def can_authorize?
    !self.expire?
  end

  def check_member_authory(openid)
	 return self.openid == openid
  end
  def init_setting
     self.create_user_setting(u_type:1)
  end
end
