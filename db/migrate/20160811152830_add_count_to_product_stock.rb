class AddCountToProductStock < ActiveRecord::Migration[5.0]
  def change
  	add_column :product_stocks,:count,:integer
  end
end
