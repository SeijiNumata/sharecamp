# frozen_string_literal: true

class CreateUsersEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :users_events do |t|
      t.integer :user_id
      t.integer :events_id

      t.timestamps
    end
  end
end
