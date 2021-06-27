class ChangeColumnToEvents < ActiveRecord::Migration[6.1]
  def up
    change_column :events, :id, :string
  end

  def down
    change_column :events, :id, :integer
  end
end
