# frozen_string_literal: true

class AddReferencesToUsersEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :users_events, :user, foreign_key: true
    add_reference :users_events, :event, foreign_key: true, type: :string
  end
end
