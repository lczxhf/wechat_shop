class CreatePayRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :pay_records do |t|
		t.references :order
		t.references :member
		t.integer :status, default: 0
		t.boolean :del, default:false
      	t.timestamps
    end
  end
end
