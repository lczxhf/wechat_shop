class AgentLevel < ApplicationRecord
  belongs_to :shop


  def self.can_authorize_agent?(agent_levels,level)
		if agent_levels.size <= 1 || !agent_levels.first.can_create_agent
			return false	
		end
		return true
  end
end
