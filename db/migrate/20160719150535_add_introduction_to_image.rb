class AddIntroductionToImage < ActiveRecord::Migration[5.0]
  def change
      add_column :images, :introduction, :string
  end
end
