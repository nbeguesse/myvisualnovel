class AddPlaysToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :views, :integer, :default=>0
  end
end
