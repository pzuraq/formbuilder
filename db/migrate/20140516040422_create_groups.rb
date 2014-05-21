class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :owner_id
      t.integer :parent_id
      t.string :name
      t.hstore :supergroups

      t.timestamps
    end
  end
end
