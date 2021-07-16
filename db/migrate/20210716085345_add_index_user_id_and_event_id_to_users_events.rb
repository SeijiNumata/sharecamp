# frozen_string_literal: true

class AddIndexUserIdAndEventIdToUsersEvents < ActiveRecord::Migration[6.1]
  def change
    add_index :users_events, %i[user_id event_id], unique: true
  end
end
