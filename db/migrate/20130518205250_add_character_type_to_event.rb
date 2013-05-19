class AddCharacterTypeToEvent < ActiveRecord::Migration
  def change
  	add_column :events, :character_type, :string
  	add_column :events, :subfilename, :string
  end
end
