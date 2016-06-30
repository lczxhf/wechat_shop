class CreateLevelDistributions < ActiveRecord::Migration[5.0]
  def change
    create_table :level_distributions do |t|
      t.references :product
      t.decimal :cost
      t.float :discount
      t.boolean :del, default: false
      t.timestamps
    end
  end
end
