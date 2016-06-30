class CreateGzhInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :gzh_infos do |t|
      t.references :gzh_config
    	t.references :user
    	t.string :nickname
    	t.string :headimgurl
    	t.integer :service_type
    	t.integer :verify_type
    	t.string :alias
    	t.string :user_name
    	t.string :qrcode_url
    	t.boolean :open_store,default: false
    	t.boolean :open_scan,default: false
    	t.boolean :open_pay,default: false
    	t.boolean :open_card,default: false
    	t.boolean :open_shake,default: false
    	t.boolean :del,default:false
      t.timestamps
    end
  end
end
