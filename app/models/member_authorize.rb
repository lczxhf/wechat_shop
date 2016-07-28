class MemberAuthorize < ApplicationRecord
    belongs_to :shop
    belongs_to :member
end
