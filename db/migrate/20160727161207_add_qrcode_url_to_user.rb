class AddQrcodeUrlToUser < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :qrcode_url, :string
  end
end
