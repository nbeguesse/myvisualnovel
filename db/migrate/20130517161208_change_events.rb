class ChangeEvents < ActiveRecord::Migration
  def up
  	remove_column :events, :file_id
  	remove_column :events, :action
  	add_column :events, :type, :string
  	add_column :events, :filename, :string
  end

  def down
  end
end
