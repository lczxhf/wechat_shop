class CreateMemberAuthorizes < ActiveRecord::Migration[5.0]
  def change
    create_table :member_authorizes do |t|
      t.references :shop
      t.references :member
      t.boolean :del,default:false
      t.timestamps
    end
  end
end
