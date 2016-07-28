class AddNameToAgentLevel < ActiveRecord::Migration[5.0]
  def change
  	add_column :agent_levels, :name, :string
  end
end
