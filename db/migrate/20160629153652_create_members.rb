class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.references :user
      t.references :gzh_config
      t.string :openid
      t.string :wechat_number
      t.string :nickname
      t.boolean :sex
      t.string :province
      t.string :city
      t.string :country
      t.string :headimgurl
      t.string :language
      t.string :subscribe_time
      t.string :remark
      t.string :realname
      t.string :alipay_account
      t.integer :phone
      t.boolean :del, default: false
      t.timestamps
    end
  end
end
