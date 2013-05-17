class CreateScenes < ActiveRecord::Migration
  def change
    create_table :scenes do |t|
      t.integer :project_id
      t.integer :order_index
      t.string :custom_description

      t.timestamps
    end
    add_index :scenes, :project_id
    add_index :characters, [:type, :project_id]
  end
end
