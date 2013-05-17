class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.integer :project_id
      t.string :name
      t.string :type
      t.timestamps
    end
    add_index :characters, :project_id
  end
end
