class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :name
      t.text :moderators
      t.text :editors

      t.timestamps
    end
  end
end
