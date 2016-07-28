class CreateProductStocks < ActiveRecord::Migration[5.0]
  def change
    create_table :product_stocks do |t|
      t.references :shop
      t.references :product
      t.references :member
      t.integer :status,default: 0
      t.boolean :del, default: false
      t.timestamps
    end
  end
end
