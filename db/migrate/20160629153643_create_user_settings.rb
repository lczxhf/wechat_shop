class CreateUserSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :user_settings do |t|
      t.references :user
      t.boolean :del, default: false
      t.timestamps
    end
  end
end
