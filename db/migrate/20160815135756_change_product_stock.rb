class ChangeProductStock < ActiveRecord::Migration[5.0]
  def change
  	add_column :product_stocks, :order_id,:integer
  end
end
