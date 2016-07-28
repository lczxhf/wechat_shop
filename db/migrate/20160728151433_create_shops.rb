class CreateShops < ActiveRecord::Migration[5.0]
  def change
    create_table :shops do |t|
      t.references :user
      t.string   :name
      t.string   :openid
      t.integer  :status,default: 0
      t.string   :phone
      t.string   :service_phone
      t.string   :service_wechat
      t.string   :address
      t.string   :qrcode_url
      t.boolean :del, default:false
      t.timestamps
    end
  end
end
