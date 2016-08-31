class AddShopIdToShareRecord < ActiveRecord::Migration[5.0]
  def change
  	add_column :share_records, :shop_id, :integer
  end
end
