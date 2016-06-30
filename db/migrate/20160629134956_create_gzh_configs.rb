class CreateGzhConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :gzh_configs do |t|
      t.references :user
      t.string :appid
      t.string :token
      t.string :refresh_token
      t.boolean :del,default: false
      t.timestamps
    end
  end
end
