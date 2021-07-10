# frozen_string_literal: true

class RenameEventsIdToUsersEvent < ActiveRecord::Migration[6.1]
  def change
    rename_column :users_events, :events_id, :event_id
  end
end
