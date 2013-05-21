class AddCharactersPresentToEvent < ActiveRecord::Migration
  def change
  	add_column :events, :characters_present, :text
  end
end
