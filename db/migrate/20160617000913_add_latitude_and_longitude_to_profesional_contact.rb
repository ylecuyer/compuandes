class AddLatitudeAndLongitudeToProfesionalContact < ActiveRecord::Migration
  def change
    add_column :profesional_contacts, :latitude, :float
    add_column :profesional_contacts, :longitude, :float
  end
end
