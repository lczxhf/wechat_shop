class CreateAgentLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :agent_levels do |t|
      t.references :user
      t.integer :level
      t.decimal :agent_min_price
      t.decimal :level_price
      t.boolean :can_create_agent, default: true
      t.timestamps
    end
  end
end
