class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
		t.references :shop
		t.references :member
		t.references :share_record
		t.string :phone
		t.string :address
		t.decimal :total_price
		t.boolean :is_store, default: false
		t.integer :status, default:0
		t.boolean :del, default: false
      	t.timestamps
    end
  end
end
