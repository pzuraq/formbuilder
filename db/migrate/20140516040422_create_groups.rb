class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :owner_id
      t.integer :parent_id
      t.string :name
      t.hstore :supergroups

      t.timestamps
    end
    execute "CREATE INDEX groups_gin_supergroups ON groups USING GIN(supergroups)"
  end
end
