class AddLevelToLevelDistribution < ActiveRecord::Migration[5.0]
  def change
  		add_column :level_distributions, :level, :integer	
  end
end
