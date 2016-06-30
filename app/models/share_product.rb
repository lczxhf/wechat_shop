class ShareProduct < ApplicationRecord
  belongs_to :product
  belongs_to :share_records
end
