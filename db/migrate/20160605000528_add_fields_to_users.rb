class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_name, :string
    add_column :users, :first_name, :string

    add_column :users, :graduate_year, :integer

    add_column :users, :linkedin, :string
    add_column :users, :facebook, :string
  end
end
