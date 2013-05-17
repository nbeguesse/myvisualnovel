class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :scene_id
      t.integer :order_index
      t.integer :character_id
      t.string :action
      t.integer :file_id

      t.timestamps
    end
    add_index :events, :scene_id
  end
end
