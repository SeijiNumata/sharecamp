# frozen_string_literal: true

class ChangeDatatypeUsersEventsOfEventsId < ActiveRecord::Migration[6.1]
  def change
    change_column :users_events, :events_id, :string
  end
end
