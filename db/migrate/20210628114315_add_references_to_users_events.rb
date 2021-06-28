class AddReferencesToUsersEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :users_events, :user, foreign_key:true
    add_reference :users_events, :event, foreign_key:true
  end
end
