class AddPriceToShareRecord < ActiveRecord::Migration[5.0]
  def change
  		add_column :share_records, :price, :decimal
  end
end
