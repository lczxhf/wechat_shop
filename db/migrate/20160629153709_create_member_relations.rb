class CreateMemberRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :member_relations do |t|
      t.references :shop
      t.integer :parent_member_id
      t.integer :child_member_id
      t.integer :level
      t.boolean :del, default: false
      t.timestamps
    end
  end
end
