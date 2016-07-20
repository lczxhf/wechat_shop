class AddInfoToUser < ActiveRecord::Migration[5.0]
  def change
      add_column :users, :phone, :string
      add_column :users, :service_phone, :string
      add_column :users, :service_wechat, :string
      add_column :users, :address, :string
  end
end
