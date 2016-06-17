class ModifyGraduateYearToFirstYear < ActiveRecord::Migration
  def change
    rename_column :users, :graduate_year, :first_year
  end
end
