class AddLoveSceneToScenes < ActiveRecord::Migration
  def change
  	add_column :scenes, :love_scene, :boolean
  	remove_column :characters, :description
  	add_column :events, :character_name, :string
  end
end
