class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.references :product
      t.references :member
      t.string :path
      t.boolean :del, default: false
      t.timestamps
    end
  end
end
