class ChangeColumnToItems < ActiveRecord::Migration[6.1]
  def change
    change_column :items, :events_id, :string
  end
end
