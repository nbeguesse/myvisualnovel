class AddGenderToCharacters < ActiveRecord::Migration
  def change
  	add_column :characters, :sex, :string, :limit=>1, :default=>"M"
  end
end
