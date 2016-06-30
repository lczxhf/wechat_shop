class Member < ApplicationRecord
  belongs_to :user
  belongs_to :gzh_config
  has_many :images
  has_many :child_members, foreign_key: 'parent_member_id'
  has_many :parent_members, foreign_key: 'child_member_id'

  has_many :to_share_records, foreign_key: 'from_member_id'
  has_many :recept_share_records, foreign_key: 'to_member_id'

end
