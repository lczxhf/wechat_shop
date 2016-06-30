class CreateQrcodeImages < ActiveRecord::Migration[5.0]
  def change
    create_table :qrcode_images do |t|
      t.references :image
      t.references :member
      t.references :product
      t.string :path
      t.boolean :del, default: false
      t.timestamps
    end
  end
end
