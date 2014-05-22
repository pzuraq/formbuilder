class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :group_id
      t.integer :user_id
      t.integer :role_rank
    end

    add_index :permissions, [:group_id, :user_id], unique: true
  end
end
