class GzhInfo < ApplicationRecord
	acts_as_cached(version:1,expires_in: 1.hour)
	belongs_to :gzh_config
	belongs_to :user

end
