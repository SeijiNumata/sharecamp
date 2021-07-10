# frozen_string_literal: true

class ChangeDatatypeUsersEventOfEventsId < ActiveRecord::Migration[6.1]
  def change
    change_column :users_events, :event_id, :string
  end
end
