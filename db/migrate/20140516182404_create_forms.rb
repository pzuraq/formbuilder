class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.integer :owner_id
      t.integer :group_id
      t.string :name
      t.text :template
      t.hstore :render_options

      # We could possibly have a set of users, :through responses. Set up tracking and all.
      t.timestamps
    end
  end
end
