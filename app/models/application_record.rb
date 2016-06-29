class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def fetch_cache(*arg)
	fetch_by_uniq_keys(*arg)
    end
  end
end
