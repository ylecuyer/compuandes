class AddLatitudeAndLongitudeToPersonalContact < ActiveRecord::Migration
  def change
    add_column :personal_contacts, :latitude, :float
    add_column :personal_contacts, :longitude, :float
  end
end
