class UserSetting < ApplicationRecord
  belongs_to :user

  enum u_type: [:user_sell,:member_sell]
end
