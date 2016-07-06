class CreateShareRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :share_records do |t|
      t.integer :from_member_id
      t.integer :to_member_id
      t.string :qrcode
      t.integer :level
      t.integer :status, default: 0
      t.boolean :del, default: false
      t.timestamps
    end
  end
end
