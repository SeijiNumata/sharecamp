# frozen_string_literal: true

class RenameEventsIdColumnToItems < ActiveRecord::Migration[6.1]
  def change
    rename_column :items, :events_id, :event_id
  end
end
