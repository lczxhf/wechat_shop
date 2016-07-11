class AddIsThresholdToProduct < ActiveRecord::Migration[5.0]
  def change
  		add_column :products, :is_threshold, :boolean
  end
end
