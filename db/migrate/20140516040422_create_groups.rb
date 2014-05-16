class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :user_id
      t.string :integer
      t.integer :group_id
      t.string :name
      t.text :moderators
      t.text :editors

      t.timestamps
    end
  end
end
