class AddFieldToMember < ActiveRecord::Migration[5.0]
  def change
	add_column :members, :nickname, :string
	add_column :members, :sex, :boolean
	add_column :members, :province, :string
	add_column :members, :city, :string
	add_column :members, :country, :string
	add_column :members, :headimgurl, :string
	add_column :members, :language, :string
	add_column :members, :subscribe_time, :string
	add_column :members, :remark, :string
  end
end
