class CreateProfesionalContact < ActiveRecord::Migration
  def change
    create_table :profesional_contacts do |t|
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.string :country
      t.string :state
      t.string :zip_code
      t.string :city
      t.string :extra
      t.string :phone
      t.string :mobile
      t.string :email
      t.string :company
      t.string :job
      t.string :company_website
      t.belongs_to :user
      t.timestamps
    end
  end
end
