class Shop < ApplicationRecord
    include Redis::Objects
    has_one :shop_setting,dependent: :destroy
    has_many :products,dependent: :destroy
    has_many :product_stocks
    has_many :agent_levels,dependent: :destroy

    mount_uploader :qrcode_url,MediaUploader

    enum status: [:probation,:normal,:expire]

    counter :agent_num

	after_create :init_setting
    def can_authorize?
      !self.expire?
    end

    def check_member_authory(openid)
  	 return self.openid == openid
    end

	def init_setting
		self.create_shop_setting
	end
end
