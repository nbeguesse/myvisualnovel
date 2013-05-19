class AddTextToEvent < ActiveRecord::Migration
  def change
  	add_column :events, :text, :string
  end
end
