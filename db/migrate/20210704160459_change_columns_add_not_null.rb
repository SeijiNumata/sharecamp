class ChangeColumnsAddNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :events, :name, false
    change_column_null :items, :event_id, false
    change_column_null :items, :name, false
    change_column_null :items, :need_number, false, 1
    change_column_null :user_bring_items, :item_id, false
    change_column_null :user_bring_items, :user_id, false
    change_column_null :user_bring_items, :bring_number, false, 1
    change_column_null :users, :name, false
    change_column_null :users_events, :user_id, false
    change_column_null :users_events, :event_id, false
  end
end
