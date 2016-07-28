class CreateShopSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :shop_settings do |t|
      t.references :shop
      t.integer  :threshold_number, default: 100
      t.boolean  :show_address,     default: true
      t.boolean  :can_alipay,       default: false
      t.boolean  :can_wechatpay,    default: true
      t.boolean  :can_unionpay,     default: false
      t.timestamps
    end
  end
end
