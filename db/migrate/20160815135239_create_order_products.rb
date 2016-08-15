class CreateOrderProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :order_products do |t|
		t.references :order
		t.references :product
		t.integer :sum
		t.decimal :price
		t.boolean :del, default: false
      	t.timestamps
    end
  end
end
