class LevelDistribution < ApplicationRecord
  belongs_to :product

  def discount_human_format
  		"#{(self.discount*100).to_i}%"
  end
end
