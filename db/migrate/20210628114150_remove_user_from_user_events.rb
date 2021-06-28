class RemoveUserFromUserEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :users_events, :user_id
    remove_column :users_events, :event_id
  end
end
