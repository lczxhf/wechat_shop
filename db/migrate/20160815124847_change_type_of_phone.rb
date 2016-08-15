class ChangeTypeOfPhone < ActiveRecord::Migration[5.0]
  def change
  	remove_column :members, :phone
	add_column :members, :phone, :string
  end
end
