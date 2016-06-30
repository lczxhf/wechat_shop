class MemberRelation < ApplicationRecord
  belongs_to :parant_member, foreign_key: 'parent_member_id'
  belongs_to :child_member, foreign_key: 'child_member_id'
end
