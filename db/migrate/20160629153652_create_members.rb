class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.references :user
      t.references :gzh_config
      t.string :openid
      t.string :wechat_number
      t.integer :phone
      t.boolean :del, default: false
      t.timestamps
    end
  end
end
