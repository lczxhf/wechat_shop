class ShareRecord < ApplicationRecord
  belongs_to :from_member, foreign_key: 'from_member_id'
  belongs_to :to_member, foreign_key: 'to_member_id'
  enum status: [:sent,:agree,:refuse,:receive,:wait_pay]

  mount_uploader :qrcode,MediaUploader
end
