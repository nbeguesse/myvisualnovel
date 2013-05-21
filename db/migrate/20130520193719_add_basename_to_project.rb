class AddBasenameToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :basename, :string
  	add_column :projects, :owner_id, :string
  	add_column :projects, :owner_type, :string
  end
end
