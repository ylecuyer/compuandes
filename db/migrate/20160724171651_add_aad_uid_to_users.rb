class AddAadUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :aad_uid, :string
  end
end
