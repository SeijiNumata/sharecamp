# frozen_string_literal: true

class AddIndexItemIdAndUserIdToUserBringItem < ActiveRecord::Migration[6.1]
  def change
    add_index :user_bring_items, %i[item_id user_id], unique: true
  end
end
