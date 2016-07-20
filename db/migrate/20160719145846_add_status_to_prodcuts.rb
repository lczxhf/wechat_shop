class AddStatusToProdcuts < ActiveRecord::Migration[5.0]
  def change
      add_column :products, :status, :integer
      add_column :products, :sentday, :integer
  end
end
