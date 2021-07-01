class CreateUserBringItems < ActiveRecord::Migration[6.1]
  def change
    create_table :user_bring_items do |t|
      t.integer :item_id, null:false, foreign_key: true
      t.integer :user_id, null: false, foreign_key:true
      t.integer :bring_number, null:false
      t.boolean :check,default:false

      t.timestamps
    end
  end
end
