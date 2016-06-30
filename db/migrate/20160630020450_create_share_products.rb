class CreateShareProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :share_products do |t|
      t.references :product
      t.references :share_record
      t.boolean :del, default: false
      t.timestamps
    end
  end
end
