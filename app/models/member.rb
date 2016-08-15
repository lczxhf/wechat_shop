class Member < ApplicationRecord
  acts_as_cached(version:1,expires_in: 3.hours)
  belongs_to :user
  belongs_to :gzh_config
  has_many :images
  has_many :products
  has_many :child_members, foreign_key: 'parent_member_id', class_name: 'MemberRelation'
  has_one :parent_member, -> {where(del:1)},foreign_key: 'child_member_id', class_name: 'MemberRelation'
  has_many :member_authorizes
  has_many :to_share_records, foreign_key: 'from_member_id', class_name: 'ShareRecord'
  has_many :recept_share_records, foreign_key: 'to_member_id', class_name: 'ShareRecord'

  has_many :product_stocks


  def has_authority?
    #  UserSetting.fetch_cache(user_id:self.user_id).user_sell? ? self.user.openid == self.openid : true
       is_own? || MemberAuthorize.fetch_cache(member_id:self.id).try(:shop)
  end

  def is_own?
    Shop.fetch_cache(openid:self.openid)
  end

  def get_shop
  	is_own? || self.parent_member.try(:shop)
  end

  def get_level
  	if is_own?
		0
	else
			parent_member.try(:level)	
	end
  end

  def get_products(params={})
  		if shop = self.get_shop
			includes = params.delete(:includes)
			if includes.present?
				Product.includes(includes).where({del:false,shop_id:shop.id}.merge(params))
			else
				Product.where({del:false,shop_id:shop.id}.merge(params))
			end
		else
			[]
		end
  end

  def get_threshold_products
  		get_products(is_threshold:true)
  end

  def get_self_stock(product)
		stock = self.product_stocks.where(product_id:product.id).first
		stock.present? ? stock.count : 0
  end
end
