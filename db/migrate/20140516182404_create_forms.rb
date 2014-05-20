class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.integer :owner_id
      t.integer :group_id
      t.string :name
      t.text :template
      t.hstore :render_options

      t.timestamps
    end
  end
end
