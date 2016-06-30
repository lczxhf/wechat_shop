class Member < ApplicationRecord
  acts_as_cached(version:1,expires_in: 3.hours)
  belongs_to :user
  belongs_to :gzh_config
  has_many :images
  has_many :child_members, foreign_key: 'parent_member_id'
  has_many :parent_members, foreign_key: 'child_member_id'

  has_many :to_share_records, foreign_key: 'from_member_id'
  has_many :recept_share_records, foreign_key: 'to_member_id'


  def has_authority?
     UserSetting.fetch_cache(user_id:self.user_id).user_sell? ? self.user.openid == self.openid : true
  end
end
