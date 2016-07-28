class Shop < ApplicationRecord
    include Redis::Objects
    has_one :shop_setting
    has_many :products
    has_many :product_stocks
    has_many :agent_levels

    mount_uploader :qrcode_url,MediaUploader

    enum status: [:probation,:normal,:expire]

    counter :agent_num
    def can_authorize?
      !self.expire?
    end

    def check_member_authory(openid)
  	 return self.openid == openid
    end
end
