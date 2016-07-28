class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.references :member
      t.references :user
      t.references :shop
      t.string :name
      t.string :mark
      t.integer :stock
      t.text :introduction
      t.decimal :postage
      t.decimal :price
      t.decimal :cost
      t.boolean :del, default: false
      t.boolean  :is_threshold, default: true
      t.integer  :status,default: 0
      t.integer  :sentday,default: 0
      t.timestamps
    end
  end
end
