class AddInfoToMember < ActiveRecord::Migration[5.0]
  def change
      add_column :members, :realname,:string
      add_column :members, :alipay_account, :string
  end
end
