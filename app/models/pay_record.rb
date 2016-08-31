class PayRecord < ApplicationRecord
	belongs_to :order
	belongs_to :member

	enum status:[:created,:pay]
end
