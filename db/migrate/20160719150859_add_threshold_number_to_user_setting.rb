class AddThresholdNumberToUserSetting < ActiveRecord::Migration[5.0]
  def change
      add_column :user_settings, :threshold_number, :integer,default:100
      add_column :user_settings, :show_address, :boolean, default: true
      add_column :user_settings, :can_alipay,:boolean, default: false
      add_column :user_settings, :can_wechatpay,:boolean, default: true
      add_column :user_settings, :can_unionpay,:boolean, default: false
  end
end
