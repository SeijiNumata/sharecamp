# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.integer :events_id
      t.text :name
      t.integer :need_number

      t.timestamps
    end
  end
end
